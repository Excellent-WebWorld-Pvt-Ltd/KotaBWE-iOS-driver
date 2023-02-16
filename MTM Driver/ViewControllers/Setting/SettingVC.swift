//
//  SettingVC.swift
//  DSP Driver
//
//  Created by Admin on 21/10/21.
//  Copyright © 2021 baps. All rights reserved.
//

import UIKit
import SDWebImage

class SettingVC: BaseViewController {
    
    //MARK:- ===== Outlets ======
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var tblSetting: UITableView!
    
    //MARK:- ===== Variables ===
    var arrSettingList = ["Profile", "Bank Details","Vehicle Details","Vehicle Document", "Change Passowrd"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.removeObserver(self, name: .updateProfile, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateProfile), name: .updateProfile, object: nil)
        self.setupNavigation(.normal(title: "Settings", leftItem: .back))
        self.lblVersion.text = "Version : \(kAPPVesion)"
        tblSetting.contentInset.top = 10
        tblSetting.registerNibCell(type: .Setting)
        tblSetting.registerNibCell(type: .ProfileInfo)
        tblSetting.reloadData()
    }
    
    @objc func UpdateProfile(){
        tblSetting.reloadData()
    }
    
    private func isAbleToChange() -> Bool {
        if let bookingInfo = Singleton.shared.bookingInfo,
           (bookingInfo.statusEnum == .accepted
            || bookingInfo.statusEnum == .traveling) {
            let message = "Please complete your current trip first!"
            UtilityClass.showAlert(message: message)
            return false
        } else {
            return true
        }
    }
    
}

extension SettingVC : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSettingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellType.ProfileInfo.rawValue, for: indexPath) as! ProfileInfoTableViewCell
        
                 let userName = "\(Singleton.shared.userProfile?.responseObject.firstName ?? "")" +  " " + "\(Singleton.shared.userProfile?.responseObject.lastName  ?? "")"
                cell.lblName.text = userName
        
            cell.lblEmail.text = Singleton.shared.userProfile?.responseObject.email
            cell.lblMobileNo.text = "\(Singleton.shared.countryCode) \(Singleton.shared.userProfile?.responseObject.mobileNo ?? "")"  //Singleton.shared.userProfile?.responseObject.mobileNo
            if let imageStr = Singleton.shared.userProfile?.responseObject.profileImage.toImageUrl(), let imageUrl = URL(string: imageStr) {
                cell.imgProfile.sd_setImage(with: imageUrl, placeholderImage: AppImages.userPlaceholder.image)
            }
           
            cell.editClicked = { [weak self] in
                let profileVC = AppViewControllers.shared.profile(forSettings: true)
                self?.push(profileVC)
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellType.Setting.rawValue, for: indexPath) as! SettingTableViewCell
            cell.lblTitle.text = arrSettingList[indexPath.row]

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 120
        }
        else{
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let profileVC = AppViewControllers.shared.profile(forSettings: true)
            self.push(profileVC)
        case 1:
            let bankinfoVC = AppViewControllers.shared.bankInfo
            bankinfoVC.isFromSetting = true
            self.navigationController?.pushViewController(bankinfoVC, animated: true)
        case 2:
            guard isAbleToChange() else {
                return
            }
            let VehicleDetailVC = AppViewControllers.shared.vehicleInfo
            VehicleDetailVC.isFromSetting = true
            self.navigationController?.pushViewController(VehicleDetailVC, animated: true)
        case 3 :
            guard isAbleToChange() else {
                return
            }
            let vehicleDocumentVC = AppViewControllers.shared.vehicleDocs(isFromSettings: true)
            self.push(vehicleDocumentVC)
        case 4 :
            guard isAbleToChange() else {
                return
            }
            let vehicleDocumentVC = AppViewControllers.shared.changePassword
            self.push(vehicleDocumentVC)
        case 5:
            openWebURL(Singleton.shared.privacyURL)
        default:
            break
        }
    }
}
