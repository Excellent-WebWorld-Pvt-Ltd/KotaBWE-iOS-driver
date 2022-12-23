//
//  Colors.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 17/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

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
