//
//  Enums.swift
//  Peppea-Driver
//
//  Created by EWW-iMac Old on 25/06/19.
//  Copyright © 2019 Excellent WebWorld. All rights reserved.
//

import Foundation
import UIKit

enum Gender: String{
    case male = "male"
    case female = "female"
}
enum CarType: String{
    case rent = "rent"
    case own = "own"
}

enum AppImages: String {
    case menu           = "iconMenu"
    case back           = "iconBack"
    case menuCoupon     = "ic_mn_coupon"
    case menuHeadphones = "ic_mn_headphones"
    case menuHistory    = "ic_mn_history"
    case menuIncome     = "ic_mn_income"
    case menuPeoplePlus = "ic_mn_people_plus"
    case menuSettings   = "ic_mn_settings"
    case cash           = "ic_cash"
    case subscription   = "ic_subscription"
    case creditCard     = "ic_credit_card"
    case mPesa          = "ic_m_pesa"
    case jambopay       = "ic_jambopay"
    case wallet         = "ic_wallet"
    case authHeader     = "ic_NavBg"
    case meter          = "ic_meter"
    case notification   = "ic_NotificationBell"
    case locationPulseSmall  = "ic_location_pulse_small"
    case locationDropPulse = "ic_drop_circle"
    case userPlaceholder = "placeholder_man"
    case file           = "ic_File"


    var image: UIImage {
        return UIImage(named: rawValue)!
    }
}

enum NotificationType: String {
    case bookingChat = "booking_chat"
    case verifyCustomer = "verify_customer"
    case requestCodeForCompleteTrip = "request_code_for_complete_trip"
    case logout = "logout"
    case bookLater = "new_book_later"
}
