//
//  ColorEx.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 14/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

extension UIColor {
    
     public convenience init(custom type: Colors.Accent) {
        let r, g, b: CGFloat
        let hex: String = type.color
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff) ) / 255
                   // a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }
        print("hex value is not valid")
        self.init()
        return
    }
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIColor {
    
    static var themeColor: UIColor {
        return #colorLiteral(red: 0.8, green: 0.2, blue: 0, alpha: 1)
    }
    
    static var themeBlue: UIColor {
        return #colorLiteral(red: 0.2, green: 0, blue: 0.4, alpha: 1)
    }

    static var themeGray: UIColor {
        return #colorLiteral(red: 0.4823529412, green: 0.4823529412, blue: 0.4823529412, alpha: 1) //#7B7B7B
    }

    static var themeLightGray: UIColor {
        return #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1) // D9D9D9
    }

    static var themeBlack: UIColor {
        return .black
    }

    static var themeBackground: UIColor {
        return #colorLiteral(red: 0.9607843137, green: 0.9725490196, blue: 1, alpha: 1) // F7F7F7 F5F8FF
    }

    static var themeSuccess: UIColor {
        return #colorLiteral(red: 0, green: 0.737254902, blue: 0.2980392157, alpha: 1) // 00BC4C
    }

    static var themeFailed: UIColor {
        return #colorLiteral(red: 0.8745098039, green: 0, blue: 0, alpha: 1) // DF0000
    }


}
