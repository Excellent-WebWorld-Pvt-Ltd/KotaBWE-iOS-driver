//
//  Colors.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 17/05/19.
//  Copyright © 2019 baps. All rights reserved.
//
import UIKit
import Foundation

public struct Colors: Codable{
    var statusbar : String!
    var group: String!
    var textLight  : String!
    var textDark : String!
    var textWhite : String!
    var theme: String!
    var buttonTint: String!
    
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(Colors.self, from: data)
    }
    
    public enum Accent{
        case buttonTint
        case textLight
        case textDark
        case textWhite
        case theme
        case statusBar
        case group
        
        
        var color : String{
            guard let color = AppTheme.shared.themeData.colors else { return "000000" }
            
            switch self {
            case .buttonTint:
                return color.buttonTint
                
            case .textLight:
                return color.textLight
                
            case .textDark:
                return color.textDark
                
            case .textWhite:
                return color.textWhite
            
            case .theme:
                return color.theme
                
            case .statusBar:
                return color.statusbar
            case .group:
                return color.group
            }
        }
    }
}

extension UIColor {
    static var themePlaceHolderGrey: UIColor {
        return #colorLiteral(red: 0.09411764706, green: 0.007843137255, blue: 0.1803921569, alpha: 0.4) // #18022E 40%
    }
    
    static var themeTextBlackColor: UIColor {
        return #colorLiteral(red: 0.09411764706, green: 0.007843137255, blue: 0.1803921569, alpha: 1) //#18022E
    }
    
    static var themeTextFieldFilledBorderColor: UIColor {
        return #colorLiteral(red: 0.8, green: 0.2, blue: 0, alpha: 1) //#CC3300
    }
    static var themeTextFieldTitleColor: UIColor {
        return #colorLiteral(red: 0.09411764706, green: 0.007843137255, blue: 0.1803921569, alpha: 0.6) //#18022E 60%
    }
    
    static var themeTextFieldDefaultBorderColor: UIColor {
        return #colorLiteral(red: 0.8, green: 0.2, blue: 0, alpha: 0.2) //#CC3300 20%
    }
}
