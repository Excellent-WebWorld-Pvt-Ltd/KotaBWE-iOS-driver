//
//  DashboardEvent.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 29/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

enum DriverState: CaseIterable{
    
    case duty
    case available
    case request
    case requestAccepted
    case arrived
    case waiting
    case inTrip
    case tripComplete
    
    case requestRejected
    case cancelTrip
    case stopWaiting
    
    case lastCompleteView
    
    
    
    func setTitle()->String{
        switch self {
        case .request:
           return "Slide To Accept"
        case .arrived :
           return "Start Ride"
        case .inTrip :
            return "Completed"
        case .tripComplete :
            return "Completed"
        case .requestAccepted :
            return "Arrived"
        default:
            return ""
        }
        
    }

    var nextCase : DriverState{
        let allCases = type(of: self).allCases
        return allCases[(allCases.index(of: self)! + 1) % allCases.count]
    }
   
    func fromNib<T: UIView>() -> T {
        switch self{
        case .request :
            let myCustomView: DriverInfoView = .fromNib()
            myCustomView.setDriverData(status: self)
            return myCustomView as! T
        case .duty :
            let myCustomView: DutyOnOffView = .fromNib()
            //myCustomView.setDriverData()
            return myCustomView as! T
        case .available:
            let myCustomView: DriverInfoView = .fromNib()
            myCustomView.driverState = self
            //myCustomView.setDriverData()
            return myCustomView as! T
        case .lastCompleteView:
            let myCustomView: CompleteView = .fromNib()
            myCustomView.setData()
            return myCustomView as! T
        default:
            let myCustomView: DriverInfoView = .fromNib()
            myCustomView.setDriverData(status: self)
            return myCustomView as! T
        }
    }
    
    var presentIndex: Int {
        let allCases = type(of: self).allCases
        return allCases.index(of: self)!
    }
    var previousIndex: Int {
        let allCases = type(of: self).allCases
        guard allCases.index(of: self)! > 0 else{
            return 0
        }
        return allCases.index(of: self)! - 1
    }
    var presentType: DriverState{
        return type(of: self).allCases[presentIndex]
    }
    var previousType: DriverState{
        return type(of: self).allCases[previousIndex]
    }
    mutating func nextView<T: UIView>() -> T{
        let allCases = type(of: self).allCases
        self = allCases[(allCases.index(of: self)! + 1) % allCases.count]
        return fromNib()
    }
    mutating func previousView<T: UIView>() -> T{
        let allCases = type(of: self).allCases
        self = allCases[(allCases.index(of: self)! - 1 + allCases.count) % allCases.count]
        return fromNib()
    }
    
    mutating func chooseTripMode<T: UIView>(state: DriverState) -> T{
//        let allCases = type(of: self).AllCases
        
        self = state // allCases[(allCases.index(of: self)! + 1) % allCases.count]
        return fromNib()
    }
   
}

