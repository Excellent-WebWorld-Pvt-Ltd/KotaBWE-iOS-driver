//
//  InitResponse.swift
//  MTM Driver
//
//  Created by Gaurang on 11/11/22.
//  Copyright © 2022 baps. All rights reserved.
//

import Foundation
import SwiftyJSON
class InitResponse: CommonApiResponse {
    let sessionExpired: Bool
    let maintenance: Bool
    let docExpired: String
    let waitingTime: String
    let isUpdateAvaialable: Bool
    let isUpdateApp: String
    let expCompareDate: String
    let privacyURL: String
    let termConditionURL: String
    let otpAutoFill: Bool
    let currency: String
    let inviteMessage: String
    let sosNumber: String
    let currentTime: String
    // Driver info
    let driverDutyInfo: DriverDutyInfo?
    // classes
    let bookingInfo: BookingInfo?
    let meterInfo: MeterInfo?
    let subscription: SubscriptionDetailsModel?
    let autoFillOTP: Bool
    let countryCode: String
    
    required init(json: JSON) {
        privacyURL = json["privacy_policy_url"].stringValue
        termConditionURL = json["terms_condition_url"].stringValue
        otpAutoFill = json["otp_auto_fill"].boolValue
        inviteMessage = json["invite_message"].stringValue
        currency = json["currency"].stringValue
        sosNumber = json["sos_number"].stringValue
        expCompareDate = json["exp_compare_date"].stringValue
        currentTime = json["current_time"].stringValue
        sessionExpired = json["is_expired"].intValue != 1
        docExpired = json["doc_expired"].stringValue
        waitingTime = json["waiting_time"].stringValue
        isUpdateAvaialable = json["update"].boolValue
        maintenance = json["maintenance"].boolValue
        isUpdateApp = json["ios_update"].stringValue
        bookingInfo = BookingInfo(fromJson: json["booking_info"])
        meterInfo = MeterInfo(fromJson: json["meter_info"])
        subscription = SubscriptionDetailsModel(json: json["subscription"])
        driverDutyInfo = DriverDutyInfo(json: json["booking_info"])
        autoFillOTP = json["otp_auto_fill_ios"].boolValue
        countryCode = json["country_code"].stringValue
        super.init(json: json)
    }
    
    
}

struct DriverDutyInfo: JSonParsable {
    let driverDuty: Bool
    let totalDriverEarning: String
    let totalTrips: String
    
    init?(json:JSON) {
        guard json["driver_duty"].exists() else {
            return nil
        }
        driverDuty = json["driver_duty"].boolValue
        totalDriverEarning = json["total_driver_earning"].stringValue
        totalTrips = json["total_trips"].stringValue
    }
}
