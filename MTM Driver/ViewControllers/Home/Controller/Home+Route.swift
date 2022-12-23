//
//  Home+Route.swift
//  MTM Driver
//
//  Created by Gaurang on 08/12/22.
//  Copyright © 2022 baps. All rights reserved.
//

import Foundation
import GoogleMaps
import CoreLocation

extension HomeViewController {

    func drawRouteOnGoogleMap(forRedraw: Bool = false) {
        guard let locations = self.getRouteLocations() else {
            self.polyline?.map = nil
            self.polyline = nil
            self.originalRouteCoordinates = []
            self.routeCoordinates = []
            return
        }
        let origin = locations.start
        let destination = locations.end
        let urlString = "\(baseURLDirections)origin=\(origin.stringValue)&destination=\(destination.stringValue)&key=\(AppDelegate.shared.googlApiKey)"
        print ("directionsURLString: \(urlString)")
        guard let directionsURL = URL(string: urlString) else {
            return
        }
        self.endTimer()
        URLSession.shared.dataTask(with: directionsURL) { data, _, error in
            if let error = error {
                print(error)
            }
            guard let data = data else {
                return
            }
            do {
                let object = try JSONSerialization.jsonObject(with: data)
                print(object)
                guard let dict = object as? [String: Any],
                      let routes = dict["routes"] as? NSArray,
                      let selectedRoute = routes.firstObject as? [String: Any],
                      let routeOverviewPolyline = selectedRoute["overview_polyline"] as? [String: Any] else {
                    return
                }
                let legs = selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>
                
                let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                let destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                DispatchQueue.main.async {
                    if forRedraw == false {
                        self.setupMarkerOnGooglMap(markerType: .to, cordinate: destinationCoordinate)
                    }
                    self.drawPoyLineOnGoogleMap(poliLinePoints: routeOverviewPolyline)
                    self.startTimer()
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func drawPoyLineOnGoogleMap(poliLinePoints: [String: Any]) {
        let route = poliLinePoints["points"] as! String
        let path = GMSPath(fromEncodedPath: route)!
        let array = path.getCoordinates()
        self.originalRouteCoordinates = array
        self.routeCoordinates = array
        drawPolylineFromRoute()
    }
    
    func drawPolylineFromRoute() {
        let path = GMSMutablePath()
        for row in self.routeCoordinates {
            path.add(row)
        }
        self.polyline?.map = nil
        let routePolyline = GMSPolyline(path: path)
        routePolyline.map = self.mapView
        routePolyline.strokeColor = .themeColor
        routePolyline.strokeWidth = 3.0
        self.polyline = routePolyline
    }
    
    func updateTravelledPath(currentLoc: CLLocationCoordinate2D){
        guard self.originalRouteCoordinates.isNotEmpty else {
            return
        }
        var index = 0
        var closestDistance: Double = 0
        for (i, row) in self.originalRouteCoordinates.enumerated() {
            let distance = row.distance(to: currentLoc)
            if closestDistance == 0 {
                index = i
                closestDistance = distance
            } else if closestDistance > distance {
                index = i
                closestDistance = distance
            }
            print("Distance: ", distance)
            if distance <= 30 {
                break
            }
        }
        let nearestLocation = self.originalRouteCoordinates[index]
        let meters = nearestLocation.distance(to: currentLoc)
        
        if(meters > 100){
            print("updateTravelledPath: \(meters)")
            self.drawRouteOnGoogleMap(forRedraw: true)
        } else {
            //Creating new path from the current location to the destination
            self.routeCoordinates = []
            for i in index..<Int(self.originalRouteCoordinates.count){
                self.routeCoordinates.append(self.originalRouteCoordinates[i])
            }
            self.drawPolylineFromRoute()
        }
        
    }
    
    func getRouteLocations() -> (start: CLLocationCoordinate2D, end: CLLocationCoordinate2D)? {
        guard let location = LocationManager.shared.coordinate
              else {
            return nil
        }
        switch driverData.driverState {
        case .requestAccepted:
            guard let destinationLocation = CLLocationCoordinate2D(latString: bookingData.pickupLat ?? "", lngString: bookingData.pickupLng ?? "") else { return nil }
            return (location, destinationLocation)
        case .inTrip:
            guard let destinationLocation = CLLocationCoordinate2D(latString: bookingData.dropoffLat ?? "", lngString: bookingData.dropoffLng ?? "") else { return nil }
            return (location, destinationLocation)
        default:
            return nil
        }
    }
}


extension GMSMutablePath {
    convenience init(coordinates: [CLLocationCoordinate2D]) {
        self.init()
        for row in coordinates {
            self.add(row)
        }
    }
}

extension GMSPath {
    func getCoordinates() -> [CLLocationCoordinate2D] {
        var array: [CLLocationCoordinate2D] = []
        for index in 0..<self.count() {
            array.append(self.coordinate(at: index))
            if index < (self.count() - 1) {
                array += coordinate(at: index).getNewCoordinates(to: coordinate(at: index+1))
            }
        }
        return array
    }
}

extension CLLocationCoordinate2D {
    func getNewCoordinates(to: CLLocationCoordinate2D) -> [CLLocationCoordinate2D] {
        let distance = self.distance(to: to)
        var coordinates: [CLLocationCoordinate2D] = []
        let coordinateCount = Double(distance / 30)
        if coordinateCount < 1 {
            return []
        }
        let latitudeDiff = self.latitude - to.latitude
        let longitudeDiff = self.longitude - to.longitude
        let latMultiplier = latitudeDiff / (coordinateCount + 1)
        let longMultiplier = longitudeDiff / (coordinateCount + 1)
        for index in 1...Int(coordinateCount) {
            let lat  = self.latitude - (latMultiplier * Double(index))
            let long = self.longitude - (longMultiplier * Double(index))
            let point = CLLocationCoordinate2D(latitude: lat.rounded(toPlaces: 5), longitude: long.rounded(toPlaces: 5))
            coordinates.append(point)
        }
        return coordinates
    }
}
