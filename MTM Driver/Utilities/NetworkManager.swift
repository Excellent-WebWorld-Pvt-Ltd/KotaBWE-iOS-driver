//
//  NetworkManager.swift
//  MTM Driver
//
//  Created by Gaurang on 16/11/22.
//  Copyright © 2022 baps. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    //shared instance
    static let shared = NetworkManager()
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
    func startNetworkReachabilityObserver() {
        
        reachabilityManager?.listener = { status in
            switch status {
                
            case .notReachable:
                print("The network is not reachable")
                NoInternetView.show()
            case .unknown :
                print("It is unknown whether the network is reachable")
                NoInternetView.hide()
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
                NoInternetView.hide()
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
                NoInternetView.hide()
            }
        }
        
        // start listening
        reachabilityManager?.startListening()
    }
}
