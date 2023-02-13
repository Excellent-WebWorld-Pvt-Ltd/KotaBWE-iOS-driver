//
//  LaunchScreenViewController.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 27/06/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import AVFoundation

class SplashScreenViewController: BaseViewController {
    
    //MARK: - ===== Outlets =======
   
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnSkip: ThemePrimaryButton!
    @IBOutlet weak var btnLogin: ThemePrimaryButton!
    @IBOutlet weak var btnRegister: ThemePrimaryButton!
    @IBOutlet weak var stackRegister: UIStackView!
    
    var isOptionalPass : Bool = false
    var playerLooper: AVPlayerLooper!
    var queuePlayer: AVQueuePlayer!
    var isAPICompleted = false
    var btnClicked = false
    var btnLoginClicked = false
    
    //MARK: - ===== View Controller Life Cycle ======
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.startNetworkReachabilityObserver()
        self.btnLogin.isHidden = true
        self.btnRegister.isHidden = true
        self.btnSkip.isHidden = true
        self.playLogoAnimation()
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
            dictData["key"] = "ios_driver/\(Helper.appVersion)"
        }
    
        WebService.shared.requestMethod(api: .Init, httpMethod: .get, parameters: dictData) { (json, status) in
            let model = InitResponse(json: json)
            Singleton.shared.bookingInfo = nil
            if(model.isUpdateApp != ""){
                self.handleAPIRepsonse(model, updateCheck: true)
            }else if model.maintenance{
                self.handleMaintenanceRepsonse(model)
            }else{
                self.handleAPIRepsonse(model)
            }
        }
    }
    
    
    func setupUIForVideoPlay() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0) {
                self.stackRegister.transform = CGAffineTransform(translationX: 0, y: (72 + Helper.bottomSafeAreaHeight))
            } completion: { _ in
                UIView.animate(withDuration: 0.8) {
                    self.stackRegister.transform = .identity
                }
            }
        }
        viewContainer.isHidden = false
        stackRegister.isHidden = false
        if(SessionManager.shared.isUserLoggedIn){
            btnLogin.isHidden = true
            btnRegister.isHidden = true
            btnSkip.isHidden = false
        }else {
            self.isAPICompleted = false
            webserviceCallForInit()
            btnLogin.isHidden = false
            btnRegister.isHidden = false
            btnSkip.isHidden = true
        }
    }
    
    func openLoginRegistration(flag:Bool){
        if flag{
            let login = AppViewControllers.shared.login
            let navVC = UINavigationController(rootViewController: login)
            Helper.currentWindow.rootViewController = navVC
        }else{
            let onbording = AppViewControllers.shared.registration
            let navVC = UINavigationController(rootViewController: onbording)
            Helper.currentWindow.rootViewController = navVC
        }
    }
    
    func playLogoAnimation() {
        guard let path = Bundle.main.path(forResource: "SplashVideo", ofType:"mp4") else {
            //        guard let path = Bundle.main.path(forResource: "White Conv", ofType:"mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        guard let url = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4") else {
            return
        }
        
        let playerItem = AVPlayerItem(url: URL(fileURLWithPath: path))
        
        self.queuePlayer = AVQueuePlayer(playerItem: playerItem)
        //        let player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: queuePlayer)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = AVLayerVideoGravity.resize
        playerLayer.backgroundColor = UIColor.clear.cgColor
        viewContainer.backgroundColor = UIColor.clear
        self.playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        
        viewContainer.layer.addSublayer(playerLayer)
        queuePlayer.play()
        self.setupUIForVideoPlay()
        //        player.rate = 1.5
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
            self.isAPICompleted = true
            Singleton.shared.fillInfo(from: model)
            if SessionManager.shared.isUserLoggedIn,
                let loginModel = SessionManager.shared.userProfile {
                loginModel.subscription = model.subscription
                Singleton.shared.userProfile = loginModel
                Singleton.shared.driverId = loginModel.responseObject.id
                AppDelegate.shared.setHome()
            } else {
                if btnClicked{
                    openLoginRegistration(flag: self.btnLoginClicked)
                }
//                AppDelegate.shared.setLogin()
            }
        }
        else {
            if model.sessionExpired {
                SessionManager.shared.splashLogout()
                setupUIForVideoPlay()
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
    
    @IBAction func btnLogin(_ sender: UIButton) {
        self.btnClicked = true
        self.btnLoginClicked = true
        viewContainer.isHidden = true
        stackRegister.isHidden = true
        if isAPICompleted{
            self.openLoginRegistration(flag: true)
        }
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
        self.btnClicked = true
        viewContainer.isHidden = true
        stackRegister.isHidden = true
        if isAPICompleted{
            self.openLoginRegistration(flag: false)
        }
    }
    
    @IBAction func btnSkipClick(_ sender: Any) {
        self.webserviceCallForInit()
        viewContainer.isHidden = true
        stackRegister.isHidden = true
    }
    
}
