//
//  Constants.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 27/06/19.
//  Copyright © 2019 baps. All rights reserved.
//
import Foundation
import UIKit


let kAPPVesion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

let Currency = "Ksh"
let measurement = "mi"
let zoomLevel: Float = 16.0


let hidePasswordImg = UIImage(named: "ic_hidePasswordRed")
let showPasswordImg = UIImage(named: "ic_showPasswordRed")

let PaymentSuccessURL = "https://showfaride.com/panel/flutterwave/payment_success"
let PaymentFailureURL = "https://showfaride.com/panel/flutterwave/payment_failed"

let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"

let appdel = UIApplication.shared

class Helper: NSObject {

    static var topSafeAreaHeight: CGFloat {
        return Helper.currentWindow.safeAreaInsets.top
    }

    static var bottomSafeAreaHeight: CGFloat {
        return Helper.currentWindow.safeAreaInsets.bottom
    }

    static var currentWindow: UIWindow {
        return UIApplication.shared.windows.first!
    }

    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return currentWindow.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    static var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }
    
    static var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
    }
    
    static var appStoreLink = "https://apps.apple.com/us/app/showfa-driver/id6443829569"
    
    static var isLogEnabled: Bool = true
    
    static func triggerHapticFeedback(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(notificationType)
    }
    
    static func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map { _ in letters.randomElement()! })
    }
}
