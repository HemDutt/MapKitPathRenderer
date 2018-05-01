//
//  MapKitPathRenderer.swift
//  MapKitPathRenderer
//
//  Created by Hem Dutt on 27/04/18.
//

import UIKit
import MapKit

struct MapSourceDestinationStruct
{
    var sourceCoordinate : CLLocationCoordinate2D? = nil
    var destinationCoordinate : CLLocationCoordinate2D? = nil
}

//defaultStepCount is the count of points needed between source and destiation coordinates
//let defaultStepCount = 20

public class MapKitPathRenderer: NSObject
{
    public func getRoutePathBetween(source : CLLocationCoordinate2D , destination : CLLocationCoordinate2D , straightLinePath : Bool = true ,steps : Int = 20) -> (MKPolyline?, [CLLocationCoordinate2D]?)
    {
        if straightLinePath == true
        {
            //Return  straight line route between source, destination points
            return MKPRStraightLineRoute.init().getRoutePathBetween(source: source, destination: destination, steps: steps)
        }
        
        return (nil , nil)
    }
    
    func getRoutesForSourceDestinatonStructArray(_ sdArray : [MapSourceDestinationStruct] ,straightLinePath : Bool = true, steps : Int = 20) -> [MKPolyline]
    {
        var routes : [MKPolyline] = Array<MKPolyline>.init()
        if straightLinePath == true
        {
            //Return multiple straight line routes for multiple source, destination points in sdArray
            routes = MKPRStraightLineRoute.init().getRoutesForSourceDestinatonStructArray(sdArray, steps: steps)
        }
        return routes
    }
}
