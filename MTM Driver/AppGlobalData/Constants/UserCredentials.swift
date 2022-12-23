//
//  UserCredentials.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 19/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

func isTestDevice()-> Bool{
    if NetworkEnvironment.environment == .qa {
        testNumber = "1234567890" // "bhavesh@excellentwebworld.info"
        testPassword = "12345678"
        return true
    }
    return false
}

fileprivate(set) var testNumber = ""
fileprivate(set) var testPassword = ""

var isUserLogin : Bool{
    return UserDefaults.standard.bool(forKey: "isUserLogin")
}

