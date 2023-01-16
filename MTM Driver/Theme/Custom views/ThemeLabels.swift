//
//  Themes.swift
//  Danfo_Rider
//
//  Created by Hiral Jotaniya on 15/03/21.

import UIKit

class ThemeLabel: UILabel {

    @IBInspectable var fontSize: CGFloat = 12
    @IBInspectable var Colour : UIColor = .white
    @IBInspectable var regular: Bool = false
    @IBInspectable var semibold: Bool = false
    @IBInspectable var medium: Bool = false
    @IBInspectable var bold: Bool = false
    @IBInspectable var objAlpha:CGFloat = 1
    @IBInspectable var white: Bool = false
    @IBInspectable var gray: Bool = false
    @IBInspectable var black: Bool = false
    @IBInspectable var digitNumber: Bool = false
    @IBInspectable var primary: Bool = false

    
    override func awakeFromNib() {
        super.awakeFromNib()

        setViews()
        if semibold {
            font = FontBook.semibold.font(ofSize: fontSize)
        } else if regular {
            font = FontBook.regular.font(ofSize: fontSize)
        } else if bold {
            font = FontBook.bold.font(ofSize: fontSize)
        }
        else if digitNumber{
            font = FontBook.digitNumber.font(ofSize: fontSize)
        }else if medium{
            font = FontBook.medium.font(ofSize: fontSize)
        }

        if white {
            textColor = .white.withAlphaComponent(objAlpha)
        } else if black {
            textColor = .themeBlack.withAlphaComponent(objAlpha)
        } else if gray {
            textColor = .themeGray.withAlphaComponent(objAlpha)
        } else if primary {
            textColor = .themeColor
        }
        else {
            textColor = Colour
        }
//        else if Colour != .white{
//
//        }
//        else {
//            textColor = .black
//        }
    }

    
    func setViews() {
        if semibold {
            font = FontBook.semibold.font(ofSize: fontSize)
        } else if regular {
            font = FontBook.regular.font(ofSize: fontSize)
        } else if bold {
            font = FontBook.bold.font(ofSize: fontSize)
        }

        if white {
            textColor = .white
        } else if black {
            textColor = .themeBlack
        } else if gray {
            textColor = .themeGray
        }
    }

    
}

class ThemeUnderlinedLabel: UILabel {

    override var text: String? {
        didSet {
            setUnderLineStyle()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUnderLineStyle()
    }

    private func setUnderLineStyle() {
        guard let text = text else { return }
        let attributes: [NSAttributedString.Key: Any]
            = [.underlineStyle: NSUnderlineStyle.single.rawValue,
               .font: FontBook.regular.font(ofSize: 12),
               .foregroundColor: UIColor.themeBlack]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        self.attributedText = attributedText

    }
}
