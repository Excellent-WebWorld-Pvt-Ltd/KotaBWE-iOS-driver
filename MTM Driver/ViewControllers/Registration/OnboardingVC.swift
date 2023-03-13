//
//  OnboardingVC.swift
//  DPS
//
//  Created by Gaurang on 14/11/22.
//  Copyright © 2022 Mayur iMac. All rights reserved.
//

import UIKit

class OnboardingVC: BaseViewController {

    @IBOutlet weak var btnSignIn: ThemePrimaryButton!
    @IBOutlet weak var lblTitle: ThemeLabel!
    @IBOutlet weak var btnRegister: ThemePrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localization()
        self.setUpData()
    }
    
    func setUpData(){
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    @objc func changeLanguage(){
        self.localization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func localization(){
        btnSignIn.setTitle("SIGN IN".localized, for: .normal)
        btnRegister.setTitle("REGISTER".localized, for: .normal)
        lblTitle.text = "Welcome to Kota".localized
    }
}
