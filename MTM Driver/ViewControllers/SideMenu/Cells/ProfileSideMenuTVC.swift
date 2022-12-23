//
//  ProfileSideMenuTVC.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 03/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class ProfileSideMenuTVC:  UITableViewCell {
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    func setup(user: ResponseObject){
//        let imageView = UIImageView(frame: profileImageButton.bounds)
//        imageView.setImageFromUrl(url: NetworkEnvironment.baseImageURL + user.profileImage)
//        profileImageButton.setImage(imageView.image, for: .normal)
        
        profileImageButton.sd_addActivityIndicator()
        profileImageButton.sd_setShowActivityIndicatorView(true)
        profileImageButton.sd_setIndicatorStyle(.medium)
        profileImageButton.sd_setImage(with: URL(string: NetworkEnvironment.baseImageURL + user.profileImage), for: .normal, completed: nil)
        
        labelName.text = user.firstName + " " + user.lastName
//        labelEmail.text = user.email
        
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.init(named: AppTheme.shared.themeData.colors.buttonTint)?.cgColor
        profileImageButton.layer.cornerRadius = (profileImageButton.frame.width / 2)
        profileImageButton.layer.masksToBounds = true
    }
}

class MenuTVC: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    
    func setup(data: (image: String,title: String)){
        labelTitle.text = data.title
    }
}
