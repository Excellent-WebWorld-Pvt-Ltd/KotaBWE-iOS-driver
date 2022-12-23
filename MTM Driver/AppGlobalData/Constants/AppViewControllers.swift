//
//  ViewControllers.swift
//  Populaw
//
//  Created by Gaurang on 09/09/21.
//

import UIKit
import SwiftyJSON
import SideMenuSwift

class AppViewControllers {

    static let shared = AppViewControllers()
    
    var topViewController: UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }

    var navigationCtrIfPresentedSideMenu: UINavigationController? {
        if let menuVC = self.topViewController as? SideMenuController,
           let navVC = menuVC.contentViewController as? UINavigationController {
            return navVC

        }
        return nil
    }

    var visibleVCOfCurrentNavVC: UIViewController? {
        if let navVC = navigationCtrIfPresentedSideMenu,
             let viewCtr = navVC.visibleViewController {
            return viewCtr

        }
        return nil
    }
//    // Auth
    
    var splash: SplashScreenViewController {
        getViewController(.registration)
    }
    
    var onbording: OnboardingVC {
        getViewController(.registration)
    }

    var login: LoginVC {
        getViewController(.registration)
    }
    
    var registration: RegistrationViewController {
        getViewController(.registration)
    }
    
    var otp: OTPVC {
        getViewController(.registration)
    }
    
    func profile(forSettings: Bool = false) -> ProfileInfoVC {
        let vc: ProfileInfoVC = getViewController(.registration)
        vc.isFromSetting = forSettings
        return vc
    }
    
    var bankInfo: BankInfoVC {
        getViewController(.registration)
    }
    
    var vehicleInfo: VehicleInfoVC {
        getViewController(.registration)
    }
    
    func vehicleDocs(isFromSettings: Bool) -> VehicleDocumentVC {
        let vc: VehicleDocumentVC = getViewController(.registration)
        vc.isFromSettings = isFromSettings
        return vc
    }
    
    // Trip
    var myTrips: TripHistoryVC {
        return getViewController(.myTrip)
    }
    
    var meter: MeterDisplayVC {
        return getViewController(.tripDetails)
    }

    var alertView: ThemeAlertVC {
        getViewController(.popups)
    }
    
    //Payment method
    func paymentMethod(for operation: PaymentMethodsVC.Operation) -> PaymentMethodsVC {
        let viewCtr: PaymentMethodsVC = getViewController(.payment)
        viewCtr.operation = operation
        return viewCtr
    }

    var walletHistory: WalleteViewController {
        getViewController(.payment)
    }

   var support: SupportVC {
    getViewController(.updateProfile)
   }
    
    var earnings: EarningVC {
     getViewController(.payment)
   }
    
    var creditCardList: CrediCardListVC {
        getViewController(.payment)
    }

    
    var setting: SettingVC {
        getViewController(.updateProfile)
    }
    
    var promoCode: PromoCodeVC {
        getViewController(.payment)
    }
    
    //Popups
    func bottomSheet(title: String, view: UIView , _ subTitle : String = "") -> BottomSheetViewController {
        let viewCtr: BottomSheetViewController = getViewController(.popups)
        viewCtr.titleText = title
        viewCtr.subtitle = subTitle
        viewCtr.mainContent = view
        viewCtr.modalTransitionStyle = .crossDissolve
        viewCtr.modalPresentationStyle = .overCurrentContext
        return viewCtr
    }
    
    // Chat
    func chat(bookingId: String, customerId: String, CustomerName: String) -> ChatVC {
        let viewCtr: ChatVC = getViewController(.chat)
        viewCtr.strBookingId = bookingId
        viewCtr.receiverId = customerId
        viewCtr.receiverName = CustomerName
        return viewCtr
    }
    
    var help: HelpViewController {
        getViewController(.help)
    }
    
    var ticket: TicketsViewController {
        getViewController(.help)
    }
    
    var subscription: SubscriptionListVC {
        getViewController(.subscription)
    }

    // Home

//    func scheduleTrip() -> ScheduleTripVC {
//        let viewCtr: ScheduleTripVC = getViewController(.home)
//        viewCtr.modalTransitionStyle = .crossDissolve
//        viewCtr.modalPresentationStyle = .overCurrentContext
//        return viewCtr
//    }

    // MARK: - Method to get viewCotroller from storyboard
    func getViewController<T: UIViewController>(_ storyboard: UIStoryboard.Storyboard) -> T {
        return UIStoryboard(storyboard: storyboard).instantiate()
    }

}
