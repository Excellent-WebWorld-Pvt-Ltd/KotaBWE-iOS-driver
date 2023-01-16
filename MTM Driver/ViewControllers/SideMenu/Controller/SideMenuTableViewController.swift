//
//  SideMenuTableViewController.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 03/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SideMenuSwift
import SwiftyJSON


fileprivate struct SideMenuItem {
    let icon: AppImages
    let title: String
    let type: SideMenuType
}

fileprivate enum SideMenuType: Int {
    case tripHistory
    case wallet
    case meter
    case earnings
    case subscription
    case settings
    case support
    case privacy
}

class SideMenuCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    fileprivate func setValues(_ info: SideMenuItem) {
        iconImageView.image = info.icon.image.withTintColor(UIColor.themeBlue, renderingMode: .alwaysTemplate)
        titleLabel.text = info.title
    }
}

class SideMenuTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var profileView: ThemeTouchableView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var logoutTouchView: ThemeTouchableView!
    
    //MARK:- ===== Variables =======
    var ProfileData = NSDictionary()
    var loginModelDetails : LoginModel = LoginModel()
    var logoutRequestModel : logoutModel = logoutModel()
    private let menuItemArray: [SideMenuItem] = [
       // .init(icon: .menuIncome, title: "Meter", type: .meter),
        .init(icon: .menuHistory, title: "Trip history", type: .tripHistory),
        .init(icon: .menuIncome, title: "Earnings", type: .earnings),
        //.init(icon: .subscription, title: "Membership", type: .subscription),
        //.init(icon: .menuIncome, title: "Wallet", type: .wallet),
        .init(icon: .menuSettings, title: "Settings", type: .settings),
        .init(icon: .menuHeadphones, title: "Support", type: .support),
        .init(icon: .file, title: "Privcy Policy", type: .privacy),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.titleLabel?.font = FontBook.bold.font(ofSize: 16)
        logoutTouchView.setOnClickListener { [weak self] in
            self?.logoutUser()
        }
        profileView.setOnClickListener { [weak self] in
            self?.naviate(to: .settings)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let login = SessionManager.shared.userProfile {
            loginModelDetails = login
        }
        setData()
    }
    
    func setData() {
        
        let userName = "\(Singleton.shared.userProfile?.responseObject.firstName ?? "")" +  " " + "\(Singleton.shared.userProfile?.responseObject.lastName  ?? "")"
        //lblName.text = userName
        lblName.text = "Robert D"
        
        let strImage = NetworkEnvironment.baseImageURL + (Singleton.shared.userProfile?.responseObject.profileImage ?? "")
        self.imgProfile.sd_setImage(with: URL(string: strImage), completed: nil)
        tableView.reloadData()
    }
    
    private func naviate(to type: SideMenuType) {
        guard let homeViewCtr = self.parent?.children.first?.children.first as? HomeViewController else {
            return
        }
        switch type {
        case .meter:
            sideMenuController?.hideMenu(completion: { [weak homeViewCtr] _ in
                homeViewCtr?.presentMeter()
            })
        case .tripHistory:
            let viewCtr = AppViewControllers.shared.myTrips
            homeViewCtr.push(viewCtr)
        case .wallet:
            let viewCtr = AppViewControllers.shared.walletHistory
            homeViewCtr.push(viewCtr)
        case .support :
            let viewCtr = AppViewControllers.shared.help
            homeViewCtr.push(viewCtr)
        case .earnings:
            let viewCtr = AppViewControllers.shared.earnings
            homeViewCtr.push(viewCtr)
        case .settings:
            let viewCtr = AppViewControllers.shared.setting
            homeViewCtr.push(viewCtr)
        case .subscription:
            homeViewCtr.push(AppViewControllers.shared.subscription)
        case .privacy:
            openWebURL(Singleton.shared.privacyURL)
        }
        sideMenuController?.hideMenu()
    }
    
    
    // ----------------------------------------------------
    //    // MARK: - Logout Webservice Method
    //    // ----------------------------------------------------
    //
    func webserviceForLogout() {
        let param: [String: Any] = ["driver_id": Singleton.shared.userProfile!.responseObject.id, "device_token": SessionManager.shared.fcmToken ?? ""]
        Loader.showHUD()
        WebServiceCalls.LogoutApi(strType: param) { (response, status) in
            Loader.hideHUD()
            SessionManager.shared.logout()
        }
    }
    
    
    @IBAction func btnActionLogout(_ sender: UIButton) {
        logoutUser()
    }
    
    
    private func logoutUser() {
        let alertCtr = UIAlertController(title: Helper.appName, message: "Are you sure to logout from \(Helper.appName) App?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Logout", style: .destructive) { [unowned self] _ in
//            self.webserviceForLogout()
            SessionManager.shared.logout()
           
        }
        let cancelAction = UIAlertAction(title: "Not Now", style: .cancel, handler: nil)
        alertCtr.addAction(okAction)
        alertCtr.addAction(cancelAction)
        self.sideMenuController?.hideMenu()
        self.present(alertCtr, animated: true)
        DispatchQueue.main.async {
            UtilityClass.triggerHapticFeedback(.warning)
        }
    }
    
    @IBAction func deleteAccountAction() {
        let okAction = UIAlertAction(title: "Delete", style: .destructive) { [unowned self] _ in
           // self.deleteAccountRequest()
            SessionManager.shared.logout()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        
        AppDelegate.showAlert(title: "Alert", message: "Are you sure you want to delete your \"\(Helper.appName)\" Account?", actions: [okAction, cancelAction])
        
        Helper.triggerHapticFeedback(.warning)
    }
    
    private func deleteAccountRequest() {
        let param: [String: String] = ["driver_id": Singleton.shared.userProfile?.responseObject.id ?? ""]
        
        WebServiceCalls.deleteAccountAPi(params: param) { json, status in
            if status {
                UtilityClass.showAlert(message: "\(json[ "message"])", isCancelShow: false) {
                    SessionManager.shared.logout()
                }
            }else {
                AlertMessage.showMessageForError(json.getApiMessage())
            }
        }
    }
    
}

// MARK: - Table view data source
extension SideMenuTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellMenu = tableView.dequeueReusableCell(withIdentifier: "side_menu_cell", for: indexPath) as! SideMenuCell
        cellMenu.setValues(menuItemArray[indexPath.row])
        return cellMenu
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = menuItemArray[indexPath.row]
        self.naviate(to: item.type)
        
    }
    
}
