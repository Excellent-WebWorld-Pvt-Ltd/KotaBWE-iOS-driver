//
//  Theme.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 03/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import UIKit

struct AppTheme{
    static let shared = AppTheme()
    
    var themeData : ThemeModel!
    
    private init(){
        let path = Bundle.main.path(forResource: "Theme", ofType: "plist")
        
        let settingsURL = URL(fileURLWithPath: path!)
        do{
            let data = try Data(contentsOf: settingsURL)
            let dict = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
            let jsonData = try JSONSerialization.data(withJSONObject: dict , options: .prettyPrinted)
             self.themeData = try ThemeModel(data: jsonData)
        }catch{
            print("Theme Plist can't be opened")
        }
       
        // installedFontNames()
       
       }
    
    
}




