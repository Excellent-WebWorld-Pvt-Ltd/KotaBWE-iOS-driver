//
//  Singleton.swift
//  Pappea Driver
//
//  Created by Apple on 19/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import CoreLocation

class Singleton {
    
    static let shared = Singleton()
    var countryCode = ""
    var RegisterOTP = String()
    var walletBalance = String()
    var vehicleListData : VehicleListResultModel?
    var companyListData : CompanyListModel?
    var vehicleData : [VehicleData]!
    var menufacturingYearList = [String]()
    //var CountryList : [CountryDatum]?
    var registrationModel : RegistrationModel!
    var truckTypeList = [TruckType]()
    
    /// Driver login details
    var userProfile: LoginModel?
    
    var subscriptionInfo: SubscriptionDetailsModel? {
        set {
            userProfile?.subscription = newValue
        }
        get {
            userProfile?.subscription
        }
    }
    
    var currentTime = Int()
    
    var sosNumber = ""
    
    /// Get driver ID
    var driverId = "0"
    
    /// Check Is driver is online or offline
    var isDriverOnline = false
    
    var totalDriverEarning: String  = "-"
    
    /// My current wallet balance
    var currentBalance = "0"
    
    /// Get driver currentLocation
    var driverLocation: CLLocationCoordinate2D? {
        LocationManager.shared.mostRecentLocation?.coordinate
    }
    
    /// Booking data while acceptd or started trip
    var bookingInfo: BookingInfo? {
        didSet {
            print(bookingInfo?.id  ?? "")
        }
    }
    
    var meterInfo : MeterInfo?
    
    var meterId: String {
        self.meterInfo?.meterId ?? ""
    }
    
    var CompleteTrip: CompeteTripData?
    
    var GetStartedDate = String()
    
    var privacyURL: String = ""
    
    var termsAndConditionURL: String = ""
    
    var autoFillOTP: Bool = false
    
    func fillInfo(from model: InitResponse) {
        self.termsAndConditionURL = model.termConditionURL
        self.privacyURL = model.privacyURL
        if model.currentTime.isEmpty == false,
           let intCurrentTime = Int(model.currentTime) {
            self.currentTime = intCurrentTime
        }
        self.sosNumber = model.sosNumber
        self.bookingInfo = model.bookingInfo
        if let driverDutyInfo = model.driverDutyInfo {
            isDriverOnline = driverDutyInfo.driverDuty
            totalDriverEarning = driverDutyInfo.totalDriverEarning
        }
        model.meterInfo?.distance = SessionManager.shared.meterTravelDistance
        self.meterInfo = model.meterInfo
        self.autoFillOTP = model.autoFillOTP
        self.countryCode = model.countryCode
    }
}

