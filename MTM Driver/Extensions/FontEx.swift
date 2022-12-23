//
//  FontEx.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 17/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

//MARK:- UIFont

let AppRegularFont:String = "JosefinSans-Regular"
let AppBoldFont:String = "JosefinSans-Bold"
let AppSemiboldFont:String = "JosefinSans-SemiBold"
let DigiteRegular:String = "digital_numbers_regular"

extension UIFont{

    class func regular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name:  AppRegularFont, size: size)!
    }
    class func semiBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppSemiboldFont, size: size)!
    }
    class func bold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppBoldFont, size: size)!
    }
    class func DigitRegular(ofSize size: CGFloat) -> UIFont{
        return UIFont(name: DigiteRegular, size: size)!
    }

//    class func customFont(type: CustomFont.Weight, size: FontSize.Scale) -> UIFont{
//        return UIFont(name: type.fontName, size: size.size)!
//    }
//
//    class func labelCustomFonts(labels: [UILabel],
//                                type: CustomFont.Weight, size: FontSize.Scale, colorType: Colors.Accent){
//        let color = UIColor(custom: colorType)
//        guard let font = UIFont(name: type.fontName, size: size.size)
//            else{
//                labels.forEach({
//                    $0.textColor = color
//                })
//                print("Font not available, applying system fonts!")
//                return
//        }
//        labels.forEach({
//            $0.font = font
//            $0.textColor = color
//        })
//    }
//
//    class func buttonCustomFonts(buttons: [UIButton],type:  CustomFont.Weight, size: FontSize.Scale, colorType: Colors.Accent){
//
//        let color = UIColor(custom: colorType)
//        guard let font = UIFont(name: type.fontName, size: size.size) else{
//            print("Font not available, applying system fonts!")
//            return
//        }
//        buttons.forEach({
//            $0.titleLabel?.font = font
//            $0.setTitleColor(color, for: .normal)
//        })
//    }

    class func installedFontNames(){
        for family in UIFont.familyNames {
            print("\(family)")
            
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
    }
}

enum FontBook {
    
    case regular, semibold, bold , digitNumber

    func font(ofSize fontSize: CGFloat) -> UIFont {
        switch self{
        case .regular:
            return UIFont(name: "JosefinSans-Regular", size: fontSize)!
        case .semibold:
            return UIFont(name: "JosefinSans-SemiBold", size: fontSize)!
        case .bold:
            return UIFont(name: "JosefinSans-Bold", size: fontSize)!
        case .digitNumber:
            return UIFont(name: "digitalnumbers-regular", size: fontSize)!
        }
    }
}

extension UIFont {

    static var themeNavigationTitle: UIFont {
        FontBook.bold.font(ofSize: 20)
    }

    static var themeButtonTitle: UIFont {
        FontBook.bold.font(ofSize: 14)
    }

}

