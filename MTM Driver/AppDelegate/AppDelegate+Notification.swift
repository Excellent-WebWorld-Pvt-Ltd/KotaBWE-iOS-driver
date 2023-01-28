//
//  AppDelegate+Notification.swift
//  MTM Driver
//
//  Created by Gaurang on 29/09/22.
//  Copyright © 2022 baps. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseMessaging
import SideMenuSwift

extension AppDelegate {
    
    func configFirebase() {
        FirebaseApp.configure()
        setupPushNotification()
    }
    
    func setupPushNotification() {
        Messaging.messaging().delegate = self
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        center.requestAuthorization(options: authOptions, completionHandler: {_ , _ in })
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if UIApplication.shared.applicationState != .active {
            self.logoutUserInfo = userInfo
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func getNotificationTypeFrom(userInfo: [AnyHashable: Any])  -> NotificationType? {
        if let typeStr = userInfo["gcm.notification.type"] as? String,
           let notificationType = NotificationType(rawValue: typeStr)  {
            return notificationType
        }
        return nil
    }

    func handleChatNotificationNeedPresented(userInfo: [AnyHashable: Any]) {
        guard let response = userInfo["gcm.notification.data"] as? String,
              let jsonData = response.data(using: .utf8)
        else {
            return
        }
        do {
            let array = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
            guard let info = (array as? [[String: Any]])?.first,
                  SessionManager.shared.isUserLoggedIn else {
                return
            }
            let appState = UIApplication.shared.applicationState

            if appState == .active,
               let loggedVC = AppViewControllers.shared.navigationCtrIfPresentedSideMenu,
               let chatMessage = ChatMessage.getObjectFrom(info: info),
               let bookingId = info["booking_id"] as? String {
                self.notificationInfo = nil
                var driverName = ""
                if let senderInfo = info["sender_info"] as? [String: String] {
                    let firstName = senderInfo["first_name"]
                    let lastName = senderInfo["last_name"]
                    driverName = [firstName, lastName].compactMap({$0}).joined(separator: " ")
                }
                let chatVC = AppViewControllers.shared.chat(bookingId: bookingId, customerId: chatMessage.senderId, CustomerName: driverName)
                loggedVC.pushViewController(chatVC, animated: false)
            }
        } catch {
            print(#function, error.localizedDescription)
        }
    }

    func handleChatNotificationIfVCPresented(userInfo: [AnyHashable: Any]) -> Bool {
        guard let chatVC = AppViewControllers.shared.visibleVCOfCurrentNavVC as? ChatVC,
              let response = userInfo["gcm.notification.data"] as? String,
              let jsonData = response.data(using: .utf8)
        else {
            return false
        }
        do {
            let array = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
            guard let info = (array as? [[String: Any]])?.first else {
                return false
            }
            if let senderID = info["sender_id"] as? String {
                if senderID == chatVC.receiverId || (info["booking_id"] as? String) ==  chatVC.strBookingId {
                    if let chatMessage = ChatMessage.getObjectFrom(info: info) {
                        chatVC.addNewMessage(chatMessage, animated: true)
                        return true
                    } else {
                        return false
                    }
                } else {
                    return false
                }
            }
        } catch {
            print(#function, error.localizedDescription)
            return false
        }
        return false
    }
    
    //MARK:- ==== Chat Screen Navigation =====
    func chatClickToNavigate(){
        guard let bookingData = Singleton.shared.bookingInfo else {
            return
        }
        let chatVC: ChatVC = ChatVC.viewControllerInstance(storyBoard: .myTrips)
        chatVC.strBookingId = bookingData.id
        chatVC.receiverId =  bookingData.customerId ?? ""
        chatVC.receiverName = bookingData.customerInfo.getFullName()
        chatVC.receiverImage = "\(NetworkEnvironment.baseImageURL + bookingData.customerInfo.profileImage)"
        self.navigate(to: chatVC)
    }
    
    //MARK:- ====== Book Later Navigation ====
    func bookLaterNavigation(){
        navigate(to: AppViewControllers.shared.myTrips)
    }
    
    func navigate(to viewCtr: UIViewController) {
        guard let loggedVC = AppViewControllers.shared.navigationCtrIfPresentedSideMenu else {
            return
        }
        loggedVC.pushViewController(viewCtr, animated: true)
    }
}

// MARK: - User notification center delegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Without touch on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        self.notificationInfo = nil
        let userInfo = notification.request.content.userInfo
        print("Notification content", userInfo)
        guard let notificationType = getNotificationTypeFrom(userInfo: userInfo) else {
            completionHandler([.alert, .sound])
            return
        }
        if notificationType == .bookingChat {
            if handleChatNotificationIfVCPresented(userInfo: userInfo) {
                completionHandler([])
                return
            } else {
                completionHandler([.alert, .sound])
                return
            }
        }
       else if notificationType == .logout {
           SessionManager.shared.logout()
        completionHandler([.alert, .sound])
           return
        }
       else if notificationType == .bookLater {
          completionHandler([.alert, .sound])
           return
       }
        else {
            completionHandler([.alert, .sound])
            return
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("Notification content", userInfo)
        guard let notificationType = getNotificationTypeFrom(userInfo: userInfo) else {
            completionHandler()
            return 
        }
        switch notificationType {
        case .bookingChat:
            chatClickToNavigate()
        case .verifyCustomer:
            break
        case .requestCodeForCompleteTrip:
            break
        case .logout:
            SessionManager.shared.logout()
        case .bookLater:
            bookLaterNavigation()
        }
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM Token:", fcmToken ?? "")
    }
}


