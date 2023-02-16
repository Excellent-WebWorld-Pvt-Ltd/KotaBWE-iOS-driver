//
//  AppDelegate.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 26/06/19.
//  Copyright © 2019 baps. All rights reserved.
//


import UIKit
import IQKeyboardManagerSwift
import SideMenuSwift
import GoogleMaps
import GooglePlaces
import SocketIO
import Firebase
import FirebaseMessaging
import UserNotifications
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    
    var window: UIWindow?
    var resetMap : (() -> ())?
    
    let googlApiKey = "AIzaSyD3XBB16aYLWvlKyQ5DRh1gpAt31IIA9lI"
    let googlPlacesApiKey = "AIzaSyD3XBB16aYLWvlKyQ5DRh1gpAt31IIA9lI"
    
    var gcmMessageIDKey = String()
    var notificationInfo: [AnyHashable: Any]?
    var logoutUserInfo: [AnyHashable: Any]?

    static var shared: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initalSetup()
        setUpUserData()
        manageRegisterParameter()
        setupKeyboard()
        setupUI()
        setSplash()
        self.locationUpdate()
        return true
    }
    
    private func initalSetup() {
        configFirebase()
        GMSServices.provideAPIKey(googlApiKey)
        GMSPlacesClient.provideAPIKey(googlPlacesApiKey)
        LocationManager.shared.start()
        print("FCM token:", SessionManager.shared.fcmToken ?? "")
    }
    
    private func locationUpdate(){
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (timer) in
            if Singleton.shared.isDriverOnline{
                if LocationManager.shared.UpdateLocationStart(){
                    if  SocketIOManager.shared.socket.status == .connected {
                        print("emit calling ----------------------------------------")
                        let param = [
                            "driver_id" : "\(Singleton.shared.userProfile?.responseObject.id ?? "")",
                            "lat" : "\(LocationManager.shared.coordinate?.latitude ?? 0.0)",
                            "lng" : "\(LocationManager.shared.coordinate?.longitude ?? 0.0)"
                        ] as [String:AnyObject]
                        SocketIOManager.shared.socketEmit(for: socketApiKeys.updateDriverLocation.rawValue, with: param)
                    }else{
//                        SocketIOManager.shared.establishConnection()
                    }
                }
            }
        })
    }
    
    private func setupUI() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.tintColor = UIColor.themeColor
        setupNavigationAppearance()
        setupSideMenu()
        UITextViewWorkaround.unique.executeWorkaround()
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -200, vertical: 0), for:UIBarMetrics.default)
    }
    
    private func manageRegisterParameter() {
        if let registrationParameter = SessionManager.shared.registrationParameter {
            RegistrationParameter.shared = registrationParameter
        }
    }
    
    private func setupKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarTintColor = .themeColor
    }
    
    
    func setUpUserData() {
        guard SessionManager.shared.isUserLoggedIn,
              let profile = SessionManager.shared.userProfile else {
            return
        }
        Singleton.shared.userProfile = profile
        Singleton.shared.driverId = profile.responseObject.id
    }
    
    func setupSideMenu() {
        SideMenuController.preferences.basic.menuWidth = SCREEN_WIDTH - 60 //((SCREEN_WIDTH * 25) / 100)
        SideMenuController.preferences.basic.defaultCacheKey = "0"
        SideMenuController.preferences.basic.position = .above
        SideMenuController.preferences.basic.direction = .left
        SideMenuController.preferences.basic.enablePanGesture = true
    }

    func setSplash(){
        let vc = AppViewControllers.shared.splash.bindToNavigation()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    
    func setLogin(){
        if SessionManager.shared.registrationParameter == nil {
            let onbording = AppViewControllers.shared.onbording
            let navVC = UINavigationController(rootViewController: onbording)
            Helper.currentWindow.rootViewController = navVC
        } else {
            let login = AppViewControllers.shared.login
            let navVC = UINavigationController(rootViewController: login)
            Helper.currentWindow.rootViewController = navVC
        }
    }
    
    
    func setHome(){
        let homeVC : HomeViewController = .viewControllerInstance(storyBoard: .home)
        let menuVC : SideMenuTableViewController = .viewControllerInstance(storyBoard: .home)
        let homeNav = UINavigationController(rootViewController: homeVC)
        let vc = SideMenuController(contentViewController: homeNav, menuViewController: menuVC)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    func allSocketOffMethods() {
        
        SocketIOManager.shared.socket.off(socketApiKeys.driverarrived.rawValue)
        SocketIOManager.shared.socket.off(socketApiKeys.driverarivedPickupLocation.rawValue)
        SocketIOManager.shared.socket.off(socketApiKeys.CompleteTrip.rawValue)
       //SocketIOManager.shared.socket.off(socketApiKeys.liveTraking.rawValue)
        SocketIOManager.shared.socket.off(socketApiKeys.trackTrip.rawValue)
        SocketIOManager.shared.socket.off(socketApiKeys.updateDriverLocation.rawValue)
        SocketIOManager.shared.socket.off(socketApiKeys.WhenRequestArrived.rawValue)        // Socket Off 1
        SocketIOManager.shared.socket.off(socketApiKeys.AcceptRequest.rawValue)             // Socket Off 2
        SocketIOManager.shared.socket.off(socketApiKeys.StartTrip.rawValue)                 // Socket Off 3
        SocketIOManager.shared.socket.off(socketApiKeys.onTheWayBookingRequest.rawValue)    // Socket Off 4
        SocketIOManager.shared.socket.off(socketApiKeys.receiveTips.rawValue)               // Socket Off 5
        SocketIOManager.shared.socket.off(socketApiKeys.cancelTrip.rawValue)                // Socket Off 6
        SocketIOManager.shared.socket.off(clientEvent: .disconnect)// Socket Disconnect
        SocketIOManager.shared.socket.off(socketApiKeys.CancelBeforeAccept.rawValue)
    }

    func setupNavigationAppearance(darkStyle: Bool = true) {
        if darkStyle {
            if #available(iOS 15, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .themeBlue
                appearance.titleTextAttributes = [.font: UIFont.themeNavigationTitle,
                                                  .foregroundColor: darkStyle ? UIColor.white : UIColor.themeBlue]
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().barTintColor = darkStyle ? .themeBlue : .white
            UINavigationBar.appearance().isTranslucent = true
            UIBarButtonItem.appearance().tintColor = darkStyle ? .white : .themeBlue
            UINavigationBar.appearance().titleTextAttributes = [
                .font: UIFont.themeNavigationTitle,
                .foregroundColor: darkStyle ? UIColor.white : UIColor.themeBlue]
        } else {
            setSystemNavigationStyle()
        }
    }
    
    func setSystemNavigationStyle(barAppearance: UINavigationBar = UINavigationBar.appearance()) {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            barAppearance.standardAppearance = appearance
            barAppearance.scrollEdgeAppearance = appearance
        }
        let system = UINavigationBar()
        barAppearance.setBackgroundImage(nil, for: .default)
        barAppearance.shadowImage = system.shadowImage
        barAppearance.backgroundColor = system.backgroundColor
        barAppearance.isTranslucent = system.isTranslucent
        barAppearance.isOpaque = system.isTranslucent
        barAppearance.barTintColor = .white
        barAppearance.tintColor = system.tintColor
        barAppearance.titleTextAttributes = system.titleTextAttributes
        UIBarButtonItem.appearance().tintColor = .themeBlue
    }
    
    var backgroundUpdateTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    func endBackgroundUpdateTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskIdentifier.invalid
    }
    func applicationWillResignActive(_ application: UIApplication) {
        self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            self.endBackgroundUpdateTask()
        })
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        self.endBackgroundUpdateTask()
        
        if let logoutUserInfo = self.logoutUserInfo,
           let notificationType = getNotificationTypeFrom(userInfo: logoutUserInfo),
           notificationType == .logout{
            SessionManager.shared.logout()
        }
        self.logoutUserInfo = nil
    }

}

class UITextViewWorkaround: NSObject {

    // --------------------------------------------------------------------
    // MARK: Singleton
    // --------------------------------------------------------------------
    // make it a singleton
    static let unique = UITextViewWorkaround()

    // --------------------------------------------------------------------
    // MARK: executeWorkaround()
    // --------------------------------------------------------------------
    func executeWorkaround() {

        if #available(iOS 13.2, *) {

            NSLog("UITextViewWorkaround.unique.executeWorkaround(): we are on iOS 13.2+ no need for a workaround")

        } else {

            // name of the missing class stub
            let className = "_UITextLayoutView"

            // try to get the class
            var cls = objc_getClass(className)

            // check if class is available
            if cls == nil {

                // it's not available, so create a replacement and register it
                cls = objc_allocateClassPair(UIView.self, className, 0)
                objc_registerClassPair(cls as! AnyClass)

                #if DEBUG
                NSLog("UITextViewWorkaround.unique.executeWorkaround(): added \(className) dynamically")
               #endif
           }
        }
    }
}
