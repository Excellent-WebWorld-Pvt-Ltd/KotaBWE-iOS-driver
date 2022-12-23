//
//  Notification+Ext.swift
//  MTM Driver
//
//  Created by Gaurang on 10/11/22.
//  Copyright © 2022 baps. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let updateProfile = Notification.Name(rawValue: "showfa_update_profile")
    static let refresh = Notification.Name(rawValue: "showfa_refresh")
    static let updateOnlineStatus = Notification.Name(rawValue: "showfa_update_online_status")
    static let updateOnlineSwitch = Notification.Name(rawValue: "showfa_update_online_switch")
    static let refreshTripStatus = Notification.Name(rawValue: "showfa_refresh_trip_status")
    static let startTripTimer = Notification.Name(rawValue: "showfa_start_trip_timer")
    static let endTripTimer = Notification.Name(rawValue: "showfa_end_trip_timer")
}

enum CustomNotifictions {
    case updateProfile
    case refresh
    case refreshTripStatus
    case updateOnlineSwitch
    case updateOnlineStatus(_ isOnline: Bool)
    case startTripTimer
    case endTripTimer
}

extension NotificationCenter {
    static func postCustom(_ notification: CustomNotifictions) {
        switch notification {
        case .updateProfile:
            NotificationCenter.default.post(name: .updateProfile, object: nil)
        case .refresh:
            NotificationCenter.default.post(name: .refresh, object: nil)
        case .updateOnlineStatus(let isOnline):
            Singleton.shared.isDriverOnline = isOnline
            NotificationCenter.default.post(name: .updateOnlineSwitch, object: nil)
            NotificationCenter.default.post(name: .updateOnlineStatus, object: nil)
        case .refreshTripStatus:
            NotificationCenter.default.post(name: .refreshTripStatus, object: nil)
        case .updateOnlineSwitch:
            NotificationCenter.default.post(name: .updateOnlineSwitch, object: nil)
        case .startTripTimer:
            NotificationCenter.default.post(name: .startTripTimer, object: nil)
        case .endTripTimer:
            NotificationCenter.default.post(name: .endTripTimer, object: nil)
        }
    }
}
