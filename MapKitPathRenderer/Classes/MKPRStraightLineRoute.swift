//
//  MKPRStraightLineRoute.swift
//  MapKitPathRenderer
//
//  Created by Hem Dutt on 30/04/18.
//

import UIKit
import MapKit

class MKPRStraightLineRoute: NSObject
{
    //Get intermediate longitudes between source and destination longitudes satisfying a straight line path
    //Step count parameter has default value 20 indicating the number of points needed in path
    private func getLongitudesBetween(sourceLong:CLLocationDegrees, destinationLong:CLLocationDegrees, stepsCount:Int)-> [CLLocationDegrees]?
    {
        var array = [CLLocationDegrees]()
        
        if ( destinationLong > 0 && sourceLong > 0 )
        {
            //Destination Long and Source Long both are in Positive quadrant of MapView
            //Calculate real distance
            let distance = abs(destinationLong - sourceLong)
            let step = distance / Double(stepsCount)
            for i in 1...stepsCount
            {
                var newLong = sourceLong + (step*Double(i))
                if sourceLong > destinationLong
                {
                    newLong = sourceLong - (step*Double(i))
                }
                array.append(newLong)
            }
        }
        else if ( destinationLong < 0 && sourceLong < 0 )
        {
            //Both are in Negative Quadrant Eg: California and NewYork
            //Calculate real distance
            let distance = abs(destinationLong - sourceLong)
            let step = distance / Double(stepsCount)
            for i in 1...stepsCount
            {
                var newLong = sourceLong + (step*Double(i))
                if sourceLong > destinationLong
                {
                    newLong = sourceLong - (step*Double(i))
                }
                array.append(newLong)
            }
        }
        else if ( destinationLong < 0 && sourceLong > 0 )
        {
            //Eg: Source=Eastern Country, Destination = US City
            let distance = (180.0 - sourceLong) + 180.0 - abs(destinationLong)
            let step = distance / Double(stepsCount)
            for i in 1...stepsCount
            {
                var newLong = sourceLong + (step*Double(i))
                if newLong > 180.0
                {
                    //Date line is crossed
                    // value by which we crossed the Date line on the -ve side.
                    let excess = newLong - 180.0
                    newLong = excess - 180.0
                }
                array.append(newLong)
            }
        }
        else if ( destinationLong > 0 && sourceLong < 0 )
        {
            //Eg: Source=California, Destination =HongKong
            let distance = 180.0 - abs(sourceLong) + 180.0 - destinationLong
            let step = distance / Double(stepsCount)
            for i in 1...stepsCount
            {
                var newLong = sourceLong - (step*Double(i))
                if newLong > -180
                {
                    //Moved to Other side of Date line
                    // excess is how much we crossed the Date line on the +ve side.
                    let excess = abs(newLong) - 180.0
                    newLong = 180.0 - excess
                }
                array.append(newLong)
            }
        }
        if array.count>0
        {
            return array
        }
        return nil
    }
    
    private func getLatitudesBetween(sourceLat:CLLocationDegrees, destinationLat:CLLocationDegrees, stepsCount:Int)-> [CLLocationDegrees]?
    {
        var array = [CLLocationDegrees]()
        
        if ( destinationLat > 0 && sourceLat > 0 )
        {
            //Destination Lat and Source Lat both are in Positive quadrant
            //Calculate real distance
            let distance = abs(destinationLat - sourceLat)
            let step = distance / Double(stepsCount)
            for i in 1...stepsCount
            {
                var newLat = sourceLat + (step*Double(i))
                if sourceLat > destinationLat
                {
                    newLat = sourceLat - (step*Double(i))
                }
                array.append(newLat)
            }
        }
        else if ( destinationLat < 0 && sourceLat < 0 )
        {
            //Both are in Negative Quadrant
            //Calculate real distance
            let distance = abs(destinationLat - sourceLat)
            let step = distance / Double(stepsCount)
            for i in 1...stepsCount
            {
                var newLat = sourceLat + (step*Double(i))
                if sourceLat > destinationLat
                {
                    newLat = sourceLat - (step*Double(i))
                }
                array.append(newLat)
            }
        }
        else if ( destinationLat < 0 && sourceLat > 0 )
        {
            //Eg: Source=Eastern Country, Destination = US City
            let distance = sourceLat - destinationLat
            let step = distance / Double(stepsCount)
            for i in 1...stepsCount
            {
                let newLat = sourceLat - (step*Double(i))
                if newLat < destinationLat
                {
                    array.append(destinationLat)
                    break
                }
                array.append(newLat)
            }
        }
        else if ( destinationLat > 0 && sourceLat < 0 )
        {
            //Eg: Source=California, Destination =HongKong
            let distance = destinationLat - sourceLat
            let step = distance / Double(stepsCount)
            for i in 1...stepsCount
            {
                let newLat = sourceLat + (step*Double(i))
                if newLat > destinationLat
                {
                    array.append(destinationLat)
                    break
                }
                array.append(newLat)
            }
        }
        if array.count>0
        {
            return array
        }
        return nil
    }
    
    private func getCoordinatesBetween(source:CLLocationCoordinate2D, destination:CLLocationCoordinate2D , steps : Int)-> [CLLocationCoordinate2D]?
    {
        //Calculate points on shortest straight line between source and destination coordinates.
        var arrCoordinates = [CLLocationCoordinate2D]()
        if let arrLatitudes = getLatitudesBetween(sourceLat: source.latitude, destinationLat: destination.latitude , stepsCount: steps),
            let arrLongitudes = getLongitudesBetween(sourceLong: source.longitude, destinationLong: destination.longitude, stepsCount: steps),
            arrLatitudes.count == arrLongitudes.count
        {
            for i in 0..<arrLatitudes.count
            {
                let coordinate = CLLocationCoordinate2D(latitude: arrLatitudes[i], longitude: arrLongitudes[i])
                arrCoordinates.append(coordinate)
            }
        }
        return arrCoordinates.count>0 ? arrCoordinates : nil
    }
    
    func getRoutePathBetween(source : CLLocationCoordinate2D , destination : CLLocationCoordinate2D , steps : Int) -> (MKPolyline?, [CLLocationCoordinate2D]?)
    {
        //Return  straight line route between source, destination points
        if let pathCoord = self.getCoordinatesBetween(source: source, destination: destination , steps : steps)
        {
            //Set connection path
            let routePath = MKPolyline.init(coordinates: pathCoord, count: pathCoord.count)
            return (routePath , pathCoord)
        }
        
        return (nil, nil)
    }
    
    func getRoutesForSourceDestinatonStructArray(_ sdArray : [MapSourceDestinationStruct] , steps : Int) -> [MKPolyline]
    {
        //Return multiple straight line routes for multiple source, destination points in sdArray
        var routes : [MKPolyline] = Array<MKPolyline>.init()
        for coordinates in sdArray
        {
            if let source = coordinates.sourceCoordinate, let destination = coordinates.destinationCoordinate, let pathCoord = self.getCoordinatesBetween(source: source, destination: destination , steps: steps)
            {
                let routePath = MKPolyline.init(coordinates: pathCoord, count: pathCoord.count)
                routes.append(routePath)
            }
        }
        
        return routes
    }
}
