//
//  SideMenuContainer.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 10/05/19.	
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SideMenuSwift

class SideMenuContainer: SideMenuController{
    var sideMenuPreferences =  SideMenuController.preferences.basic
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuPreferences.statusBarBehavior = .fade

        sideMenuPreferences.menuWidth = SideMenuCase.width
        sideMenuPreferences.defaultCacheKey = "0"
        sideMenuPreferences.position = .above
        sideMenuPreferences.statusBarBehavior = .none
        sideMenuPreferences.direction = .left
        
        
        if let NavController = sideMenuController?.contentViewController as? UINavigationController {
            print(NavController.children)
          
        }
    }
}
