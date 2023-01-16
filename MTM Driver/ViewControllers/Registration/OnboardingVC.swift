//
//  OnboardingVC.swift
//  DPS
//
//  Created by Gaurang on 14/11/22.
//  Copyright © 2022 Mayur iMac. All rights reserved.
//

import UIKit

class OnboardingVC: BaseViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
}
