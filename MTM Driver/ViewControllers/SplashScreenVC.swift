//
//  LaunchScreenViewController.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 27/06/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class SplashScreenViewController: BaseViewController {
    
    //MARK: - ===== Outlets =======
   
    
    //MARK: - ===== View Controller Life Cycle ======
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.startNetworkReachabilityObserver()
        webserviceCallForInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //webserviceCallForInit()
        navType = .transparent
        self.navigationController?.isNavigationBarHidden = true
    }

    //MARK: - ====== WebService Call Init ======
    func webserviceCallForInit() {
        var dictData = [String: Any]()
        if SessionManager.shared.isUserLoggedIn {
            dictData["key"] = "ios_driver/\(Helper.appVersion)/\(Singleton.shared.driverId)/\(SessionManager.shared.fcmToken ?? "")"
        } else {
            dictData["key"] = "ios_driver/\(Helper.appVersion)/\(Singleton.shared.driverId)"
        }
    
        WebService.shared.requestMethod(api: .Init, httpMethod: .get, parameters: dictData) { (json, status) in
            let model = InitResponse(json: json)
           
            if(model.isUpdateApp != ""){
                self.handleAPIRepsonse(model, updateCheck: true)
            }else if model.maintenance{
                self.handleMaintenanceRepsonse(model)
            }else{
                self.handleAPIRepsonse(model)
            }
        }
    }
    
    private func handleMaintenanceRepsonse(_ model: InitResponse) {
        let alert = UIAlertController(title: Helper.appName, message: model.message, preferredStyle: .alert)
        let updateAction = UIAlertAction(title: "Ok", style: .default) { _ in
        }
        alert.addAction(updateAction)
        self.present(alert, animated: true)
    }
    
    private func handleAPIRepsonse(_ model: InitResponse, updateCheck: Bool = false) {

        if updateCheck {
            checkAppUpdate(model: model)
            return
            
        } else if model.status {
            Singleton.shared.fillInfo(from: model)
            if SessionManager.shared.isUserLoggedIn,
                let loginModel = SessionManager.shared.userProfile {
                loginModel.subscription = model.subscription
                Singleton.shared.userProfile = loginModel
                Singleton.shared.driverId = loginModel.responseObject.id
                AppDelegate.shared.setHome()
            } else {
                AppDelegate.shared.setLogin()
            }
        }
        else {
            if model.sessionExpired {
                AppDelegate.shared.setLogin()
                AlertMessage.showMessageForError(model.message ?? "")
            }
        }
    }
    
    private func checkAppUpdate(model: InitResponse) {
        if model.isUpdateAvaialable {
            let alert = UIAlertController(title: Helper.appName, message: model.message, preferredStyle: .alert)
            let updateAction = UIAlertAction(title: "Update", style: .default) { _ in
                if let url = URL(string: Helper.appStoreLink),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            alert.addAction(updateAction)
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: Helper.appName, message: model.message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                if model.status {
                    Singleton.shared.fillInfo(from: model)
                    if SessionManager.shared.isUserLoggedIn,
                        let loginModel = SessionManager.shared.userProfile {
                        loginModel.subscription = model.subscription
                        Singleton.shared.userProfile = loginModel
                        Singleton.shared.driverId = loginModel.responseObject.id
                        AppDelegate.shared.setHome()
                    } else {
                        AppDelegate.shared.setLogin()
                    }
                } else {
                    if model.sessionExpired {
                        AppDelegate.shared.setLogin()
                        AlertMessage.showMessageForError(model.message ?? "")
                    }
                }
            }
            let updateAction = UIAlertAction(title: "Update", style: .default) { _ in
                if let url = URL(string: Helper.appStoreLink),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            alert.addAction(cancelAction)
            alert.addAction(updateAction)
            self.present(alert, animated: true)
        }
    }
}
