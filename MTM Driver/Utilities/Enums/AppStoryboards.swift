//
//  Storyboards.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 03/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import UIKit

enum AppStoryboards: String{
    case launchScreen = "LaunchScreen"
    case registration = "Registration"
    case home = "Home"
    case recieveRequest = "RecieveRequest"
    case passengersInfo = "PassengersInfo"
    case completedTrip = "CompletedTrip"
    case updateProfile = "UpdateProfile"
    case payment = "Payment"
    case invite = "Invite"
    case wallet = "Wallet"
    case meter = "Meter"
    case termsAndConditions = "TermsAndConditions"
    case passcode = "Passcode"
    case ratingHistory = "RatingHistory"
    case tripToDestination = "TripToDestination"
    case picker = "Picker"
    case myTrips = "MyTrips"
    case tripDetails = "TripDetails"
}

enum appViewController: String{
    case tripToDestination = "TripToDestinationViewController"
    case myJobs = "myJobs"
    case changePassword = "changePassword"
}

