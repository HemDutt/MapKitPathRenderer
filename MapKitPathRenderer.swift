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
private let defaultStepCount = 20

public class MapKitPathRenderer: NSObject
{
    func getRoutePathBetween(source : CLLocationCoordinate2D , destination : CLLocationCoordinate2D , straightLinePath : Bool = true ,steps : Int = defaultStepCount) -> MKPolyline?
    {
        var routePath : MKPolyline? = nil
        if straightLinePath == true
        {
            //Return  straight line route between source, destination points
            routePath = MKPRStraightLineRoute.init().getRoutePathBetween(source: source, destination: destination, steps: steps)
        }
        
        return routePath
    }
    
    func getRoutesForSourceDestinatonStructArray(_ sdArray : [MapSourceDestinationStruct] ,straightLinePath : Bool = true, steps : Int = defaultStepCount) -> [MKPolyline]
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
