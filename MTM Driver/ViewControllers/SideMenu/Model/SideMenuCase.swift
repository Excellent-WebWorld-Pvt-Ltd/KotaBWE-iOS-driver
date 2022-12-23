//
//  SideMenuCase.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 10/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

enum SideMenuCase: String, CaseIterable{
    
    case profile = "Profile"
    case payments = "Payments"
    case wallet = "Wallet"
    case myTrip = "My Trip"
    case onDemand = "On Demand Area"
    case tripToDestination = "Trip To Destination"
    case airportQueue = "Airport Queue Management"
    case bidMyTrip = "Bid My Trip"
    case invite = "Invite"
    case logout = "Logout"
    
    
    static var width : CGFloat {
        return 280
    }
    
  
}
