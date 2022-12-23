//
//  DashboardSocketEmits.swift
//  Pappea Driver
//
//  Created by Apple on 19/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension HomeViewController: SocketEmitting {
    

    func getDriverLocation() {
        
    
        let json = [socketParam.driverId.rawValue: Singleton.shared.driverId, socketParam.lat.rawValue: Singleton.shared.driverLocation.coordinate.latitude, socketParam.lng.rawValue: Singleton.shared.driverLocation.coordinate.longitude] as [String : Any]

        if SocketIOManager.shared.socket.status == .connected {
            SocketIOManager.shared.socket.emit(socketApiKeys.updateDriverLocation.rawValue, with: [json], completion: nil)
            print(#function, "\t:\t", json)
        }
    }


    func didAcceptedRequest() {

        let json = [socketParam.driverId.rawValue: Singleton.shared.driverId, socketParam.bookingId.rawValue: Singleton.shared.bookingInfo?.id ?? ""] as [String : Any]
        SocketIOManager.shared.socket.emit(socketApiKeys.AcceptRequest.rawValue, with: [json], completion: nil)
        print(#function,"\n", json)
    }

    func didRejectedRequest() {
        let json = [socketParam.driverId.rawValue: Singleton.shared.driverId, socketParam.bookingId.rawValue: Singleton.shared.bookingInfo?.id ?? ""] as [String : Any]
        SocketIOManager.shared.socket.emit(socketApiKeys.RejectRequest.rawValue, with: [json], completion: nil)
        print(#function,"\n", json)
    }
}
