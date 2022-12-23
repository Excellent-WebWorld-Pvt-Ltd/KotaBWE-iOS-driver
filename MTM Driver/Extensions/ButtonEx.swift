//
//  ButtonEx.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 15/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

extension UIButton{
    
    static var customSwitch: UIButton{
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.backgroundColor = .clear
        button.setImage(UIImage.init(named: "iconSwitchOff"), for: .normal)
        button.setImage(UIImage.init(named: "iconSwitchOn"), for: .selected)
        return button
    }
    
    func submitButtonLayout(isDark : Bool){
        let titleColor = isDark ? UIColor(custom: .textWhite) : UIColor(custom: .theme)
        let bgColor = isDark ? UIColor(custom: .theme) : UIColor(custom: .textWhite)
        
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        self.backgroundColor = bgColor
        self.setTitleColor(titleColor, for: .normal)
        self.layer.borderColor = UIColor(custom: .theme).cgColor
        self.layer.borderWidth = 1.0
    }
    
    func setImageFromUrl(url: String) {
        
        self.imageView?.sd_addActivityIndicator()
        self.imageView?.sd_setShowActivityIndicatorView(true)
        self.imageView?.sd_setIndicatorStyle(.gray)
        
        self.sd_setImage(with: URL(string: url), for: .normal) { (image, error, cacheType, url) in
            
        }
    }
}

extension UIButton {
    func setImageColor(color: UIColor) {
        let templateImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.imageView?.image = templateImage
        self.imageView?.tintColor = color
    }
}
