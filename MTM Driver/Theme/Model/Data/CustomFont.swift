//
//  CustomFont.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 17/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

struct FontSize: Codable{
    var regular : Int!
    var large : Int!
    var small : Int!
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(FontSize.self, from: data)
    }
    
    enum Scale{
        case small
        case large
        case regular
        
         var size : CGFloat{
            guard let size = AppTheme.shared.themeData.fontSize else { return 16 }
            switch self {
            case .small:
                return CGFloat(size.small)
                
            case .large:
                return CGFloat(size.large)
                
            default:
                return CGFloat(size.regular)
            }
        }
    }
    
}

struct CustomFont: Codable{
    var bold  : String!
    var regular : String!
    var light : String!
    var semibold: String!
    var black : String!
    
    var boldItalic : String!
    var regularItalic : String!
    var lightItalic : String!
    var semiboldItalic: String!
    
    var extrabold: String!
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(CustomFont.self, from: data)
    }
    
    enum Weight{
        case semibold
        case bold
        case regular
        case light
        case black
        
        case boldItalic
        case regularItalic
        case semiboldItalic
        
        var fontName : String{
            guard let font = AppTheme.shared.themeData.customFonts  else { return ""}
            switch self {
            case .bold:
                return font.bold
            case .semibold:
                return font.semibold
                
            case .light:
                return font.light
                
            case .boldItalic:
                return font.boldItalic
                
            case .semiboldItalic:
                return font.semiboldItalic
                
            case .regularItalic:
                return font.regularItalic
                
            case .black:
                return font.black
                
            default:
                return font.regular
            }
            
        }
        
    }
}
