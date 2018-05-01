//
//  ViewController.swift
//  MapKitPathRenderer
//
//  Created by Hem Sharma on 04/27/2018.
//  Copyright (c) 2018 Hem Sharma. All rights reserved.
//

import UIKit
import MapKitPathRenderer
import MapKit

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

class ViewController: UIViewController
{

    @IBOutlet weak var mapView : MKMapView!
    var animation : MKPointAnnotation? = nil

    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        // Add two annotations
        let source = CLLocationCoordinate2D.init(latitude: 31.2304, longitude: 121.4737)
        let destination = CLLocationCoordinate2D.init(latitude: 36.7783, longitude: -119.4179)

        let annotation1 = Artwork.init(coordinate: source)
        let annotation2 = Artwork.init(coordinate: destination)
        
        mapView.addAnnotation(annotation1)
        mapView.addAnnotation(annotation2)

        //Add straight line path between annotation
        let renderer = MapKitPathRenderer()
        let routeObj = renderer.getRoutePathBetween(source: source , destination:destination)
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
}

