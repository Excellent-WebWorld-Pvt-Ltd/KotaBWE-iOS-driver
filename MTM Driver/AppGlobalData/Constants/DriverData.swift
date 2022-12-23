//
//  DriverData.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 11/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import GooglePlaces
//import GooglePlacePicker
import GoogleMaps
import CoreLocation

struct DriverData {
    static var shared = DriverData()
    
    var driverState = DriverState.duty
    {
        didSet
        {
            switch driverState {
            case .duty, .inTrip, .arrived, .requestAccepted:
                NotificationCenter.postCustom(.startTripTimer)
            default:
                NotificationCenter.postCustom(.endTripTimer)
            }
        }
    }

    private(set) var profile: User!
    
    private init(){
        let defaults = UserDefaults.standard
        do{
            try self.profile = defaults.get(objectType: User.self, forKey: "login")
        }
        catch {
            print("Driver Profile not found")
        }
    }
    
    
}


