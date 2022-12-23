//
//  HomeVC+Observer.swift
//  MTM Driver
//
//  Created by Gaurang on 10/11/22.
//  Copyright © 2022 baps. All rights reserved.
//

import UIKit

extension HomeViewController {
    
    func observeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateOnlineStatus(notification:)), name: .updateOnlineStatus, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTripStatus(notification:)), name: .refreshTripStatus, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startTimer), name: .startTripTimer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endTimer), name: .endTripTimer, object: nil)
        
    }
    
    @objc func updateOnlineStatus(notification: Notification) {
        self.setupOnlineOfflineView()
    }
    
    @objc func refreshTripStatus(notification: Notification) {
        
    }
}


