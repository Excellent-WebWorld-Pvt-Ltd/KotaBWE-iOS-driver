//
//  OnboardingVC.swift
//  DPS
//
//  Created by Gaurang on 14/11/22.
//  Copyright © 2022 Mayur iMac. All rights reserved.
//

import UIKit

class OnboardingVC: BaseViewController {

    @IBOutlet weak var headerContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation(.auth(title: "Welcome to Showfa", contentView: headerContainer))
    }
}
