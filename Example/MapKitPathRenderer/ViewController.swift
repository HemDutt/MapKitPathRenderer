//
//  ViewController.swift
//  MapKitPathRenderer
//
//  Created by Hem Sharma on 04/27/2018.
//  Copyright (c) 2018 Hem Sharma. All rights reserved.
//

import UIKit
import MapKit
import MapKitPathRenderer

//Model class
class Artwork: NSObject, MKAnnotation
{
    let coordinate: CLLocationCoordinate2D
    init(coordinate: CLLocationCoordinate2D)
    {
        self.coordinate = coordinate
        super.init()
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView : MKMapView!
    var animation : MKPointAnnotation? = nil
    
    var source: CLLocationCoordinate2D?
    var destination: CLLocationCoordinate2D?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        self.getLocationFromAddress(address: "Jaipur") { (location) in
            self.source = location
            self.renderMap()
        }
        
        self.getLocationFromAddress(address: "Taiwan") { (location) in
            self.destination = location
            self.renderMap()
        }
        
    }
    
    func renderMap() {
        guard let sourceLocation = self.source else { return }
        guard let destinationLocation = self.destination else { return }
        
        let annotation1 = Artwork.init(coordinate: sourceLocation)
        let annotation2 = Artwork.init(coordinate: destinationLocation)
        
        self.mapView.addAnnotation(annotation1)
        self.mapView.addAnnotation(annotation2)
        
        //Add straight line path between annotation
        let renderer = MapKitPathRenderer()
        let routeObj = renderer.getRoutePathBetween(source: sourceLocation , destination:destinationLocation)
        if let route = routeObj.0
        {
            self.mapView.addOverlays([route])
            self.recenterMapFor(route: route)
        }
        
        //Animate on route. We have already considered date line crossing in  the pod
        if let pathCoord = routeObj.1
        {
            if self.animation == nil
            {
                self.animation = MKPointAnnotation.init()
            }
            self.startAnimationOn(coordinates: pathCoord)
        }
    }
    
    
    @objc fileprivate func startAnimationOn(coordinates : [CLLocationCoordinate2D])
    {
        if coordinates.count >= 2
        {
            self.animation?.coordinate = coordinates[0]
            self.mapView.addAnnotation(self.animation!)
            
            self.animateOnCoordinates(array: coordinates, completionHandler: {[weak self] in
                
                //Run Animation in loop
                if self?.animation != nil
                {
                    self?.startAnimationOn(coordinates: coordinates)
                }
                
                //Stop Animation
                //self?.stopAnimation()
            })
        }
    }
    
    fileprivate func stopAnimation()
    {
        if let anotation = self.animation
        {
            mapView.removeAnnotation(anotation)
        }
        self.animation = nil
    }
    
    private func animateOnCoordinates(array:[CLLocationCoordinate2D], index:Int=0,
                                      completionHandler: @escaping()->Void)
    {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: { [weak self] in
            
            if self?.animation == nil
            {
                completionHandler()
            }
            if index < array.count-1
            {
                if self?.animation != nil
                {
                    self?.animation?.coordinate = array[index]
                    self?.animateOnCoordinates(array: array, index: index+1, completionHandler: completionHandler)
                }
                else
                {
                    completionHandler()
                }
            }
            else
            {
                completionHandler()
            }
        })
    }
    
    func recenterMapFor(route : MKPolyline)
    {
        //Recenter Map to make route in focus
        var visibleMapRect = route.boundingMapRect
        let width = visibleMapRect.size.width
        visibleMapRect.size.width = width * 1.2
        visibleMapRect.origin.x -= width * 0.1
        let height = visibleMapRect.size.height
        visibleMapRect.size.height = height * 1.2
        visibleMapRect.origin.y -= height * 0.1
        mapView.setVisibleMapRect(visibleMapRect, animated: true)
    }
}

extension ViewController : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if let annotation = annotation as? MKPointAnnotation
        {
            //Add annotation for animation
            var annotationView: MKAnnotationView
            let annotationIdentifier = "animation"
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
            {
                dequeuedView.annotation = annotation
                annotationView = dequeuedView
            }
            else
            {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            }
            
            annotationView.image = UIImage.init(named: "ball")
            return annotationView
        }
        else
        {
            //Add annotation
            let annotationIdentifier = "Ballon"
            var annotationView: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
            {
                dequeuedView.annotation = annotation
                annotationView = dequeuedView
            }
            else
            {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            }
            
            annotationView.image = UIImage.init(named: "ballon")
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        //Add overlay for route between two coordinates
        if overlay is MKPolyline
        {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 2
            return polylineRenderer
        }
        
        return MKPolylineRenderer()
    }
    
    func getLocationFromAddress(address : String, success: @escaping (CLLocationCoordinate2D?) -> Void) {
        
        let geocoder = CLGeocoder()
        var geoLocation : CLLocationCoordinate2D?
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                //Handle Errors
                geoLocation = nil
                
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                geoLocation = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
                success(geoLocation)
            }
        })
        
    }
}

