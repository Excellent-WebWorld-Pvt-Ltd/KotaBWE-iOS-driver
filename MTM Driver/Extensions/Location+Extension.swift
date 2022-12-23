//
//  Location+Extension.swift
//  DSP Driver
//
//  Created by Admin on 24/11/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {

    func bearing(to point: CLLocationCoordinate2D) -> Double {
        func degreesToRadians(_ degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
        func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / Double.pi }

        let lat1 = degreesToRadians(latitude)
        let lon1 = degreesToRadians(longitude)

        let lat2 = degreesToRadians(point.latitude);
        let lon2 = degreesToRadians(point.longitude);

        let dLon = lon2 - lon1;

        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x);
        let degree = radiansToDegrees(radiansBearing)
        return (degree >= 0) ? degree : (360 + degree)
    }

    var clLocation: CLLocation {
        .init(latitude: latitude, longitude: longitude)
    }

    var stringValue: String {
        return "\(latitude),\(longitude)"
    }

    init?(latString: String?, lngString: String?) {
        guard let latStr = latString, let lngStr = lngString,
              let lat = Double(latStr), let lng = Double(lngStr) else {
            return nil
        }
        self.init(latitude: lat, longitude: lng)
    }

    var isValidPoints: Bool {
        return latitude != 0 || longitude != 0
    }
}

extension CLLocation {

    func getAddress(_ completion: @escaping CLGeocodeCompletionHandler ) {
        CLGeocoder().reverseGeocodeLocation(self, completionHandler: completion)
    }

}



extension CLLocation  {
    
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude.rounded(toPlaces: 5), longitude: coordinate.longitude.rounded(toPlaces: 5))
    }
}

extension CLLocationCoordinate2D {
    
    func distance(to destination: CLLocationCoordinate2D) -> Double {
        return CLLocation(coordinate: self)
            .distance(from: CLLocation(coordinate: destination))
    }
    
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    
}
