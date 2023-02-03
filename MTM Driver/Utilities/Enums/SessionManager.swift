//
//  SessionManager.swift
//  DSP Driver
//
//  Created by Admin on 24/11/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation
import FirebaseMessaging
import SwiftyJSON

class SessionManager {
    static let shared = SessionManager()
    
    @UserDefault("isUserLogin", defaultValue: false)
    var isUserLoggedIn: Bool

    var fcmToken: String? {
        return Messaging.messaging().fcmToken
    }

    @UserDefault("ud_x_api_key", defaultValue: "")
    var xApiKey: String

    var userProfile: LoginModel? {
        get {
            do {
                return try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")
            } catch {
                print(error)
                return nil
            }
        }
        set {
            try? UserDefaults.standard.set(object: newValue, forKey: "userProfile")
        }
    }

    var carList: VehicleListModel? {
        get {
            try! UserDefaults.standard.get(objectType: VehicleListModel.self, forKey: "carList")
        }
        set {
            try? UserDefaults.standard.set(object: newValue, forKey: "carList")
        }
    }

    
    @UserDefault("PaymentType", defaultValue: nil)
    var paymentType: String?

    @UserDefault("ud_selected_card_id", defaultValue: nil)
    var selectedCardId: String?
    
    @UserDefault("ud_travel_distance", defaultValue: nil)
    var meterTravelDistance: Double?
    
    @UserDefault("ud_meter_duration", defaultValue: nil)
    var meterDuration: Int?
    
    var savedProfileImage: UIImage? {
        get {
            if let data = UserDefaults.standard.value(forKey: "ProfileImage") as? Data {
                return UIImage(data: data)
            } else {
                return nil
            }
        }
        set {
            if let data = newValue?.pngData() {
                UserDefaults.standard.setValue(data, forKeyPath: "ProfileImage")
            } else {
                UserDefaults.standard.removeObject(forKey: "ProfileImage")
            }
        }
    }
    
    var paymentTypeData: [String:Any]? {
        get {
            return UserDefaults.standard.object(forKey: "PaymentTypeData") as? [String:Any]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "PaymentTypeData")
        }
    }

    var cards: AddCardModel? {
        get {
            try! UserDefaults.standard.get(objectType: AddCardModel.self, forKey: "cards")
        }
        set {
            try? UserDefaults.standard.set(object: newValue, forKey: "cards")
        }
    }
    
    func saveSession(json: JSON) {
        isUserLoggedIn = true
        print(json)
        let loginModelDetails = LoginModel.init(fromJson: json)
        Singleton.shared.walletBalance = loginModelDetails.responseObject.walletBalance
        SessionManager.shared.userProfile = loginModelDetails
        DispatchQueue.main.async {
            RegistrationParameter.clear()
            RegistrationImageParameter.clear()
            SessionManager.shared.savedProfileImage = nil
            SessionManager.shared.registrationParameter = nil
            UserDefaults.standard.synchronize()
        }
        Singleton.shared.userProfile = loginModelDetails
        Singleton.shared.driverId = loginModelDetails.responseObject.id
        Singleton.shared.isDriverOnline = !(loginModelDetails.responseObject.duty == "0")
        Singleton.shared.bookingInfo = BookingInfo.init(fromJson: json["booking_info"])
        print(json["booking_info"])
        if let driverDutyInfo = DriverDutyInfo(json: json["booking_info"]) {
            Singleton.shared.isDriverOnline = driverDutyInfo.driverDuty
            Singleton.shared.totalDriverEarning = driverDutyInfo.totalDriverEarning
        }
        Singleton.shared.meterInfo = MeterInfo(fromJson: json["meter_check"])
        AppDelegate.shared.setHome()
        DispatchQueue.main.async {
            UtilityClass.triggerHapticFeedback(.success)
        }
    }

    /*
     if let PaymentObject = UserDefaults.standard.object(forKey: "PaymentTypeData") as? [String:Any] {
         didSelectPaymentType(PaymentTypeTitle: PaymentObject["CardNum"] as! String, PaymentType:  PaymentObject["CardNum2"] as! String, PaymentTypeID: "", PaymentNumber: "", PaymentHolderName: "", dictData: PaymentObject)
     }
     */

    func clear() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }


    func logout() {
        SessionManager.shared.savedProfileImage = nil
        SessionManager.shared.registrationParameter = nil
        Singleton.shared.bookingInfo = nil
        SessionManager.shared.isUserLoggedIn = false
        NotificationCenter.postCustom(.endTripTimer)
        AppDelegate.shared.allSocketOffMethods()
        SocketIOManager.shared.closeConnection()
        AppDelegate.shared.setLogin()
    }
    
    func splashLogout() {
        SessionManager.shared.savedProfileImage = nil
        SessionManager.shared.registrationParameter = nil
        Singleton.shared.bookingInfo = nil
        SessionManager.shared.isUserLoggedIn = false
        NotificationCenter.postCustom(.endTripTimer)
        AppDelegate.shared.allSocketOffMethods()
        SocketIOManager.shared.closeConnection()
    }
    
    var registrationParameter: RegistrationParameter? {
        get {
            do {
                return try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: "RegistrationParameter")
            } catch {
                print(error)
                return nil
            }
        }
        set {
            do {
                try UserDefaults.standard.set(object: newValue, forKey: "RegistrationParameter")
            } catch {
                print(error)
            }
        }
    }

}

@propertyWrapper
struct UserDefault<T> {
    private let key: String
    private let defaultValue: T
    private let userDefaults: UserDefaults

    init(_ key: String, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: T {
        get {
            guard let value = userDefaults.object(forKey: key) else {
                return defaultValue
            }

            return value as? T ?? defaultValue
        }
        set {
            if let value = newValue as? OptionalProtocol, value.isNil() {
                userDefaults.removeObject(forKey: key)
            } else {
                userDefaults.set(newValue, forKey: key)
            }
        }
    }
}

private protocol OptionalProtocol {
    func isNil() -> Bool
}

extension Optional: OptionalProtocol {
    func isNil() -> Bool {
        return self == nil
    }
}
