//
//  ThemeTextField.swift
//  Peppea
//
//  Created by Mayur iMac on 28/06/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ThemeTextFieldLoginRegister: SkyFloatingLabelTextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleColor = UIColor.clear
        self.selectedLineHeight = 1.0
        self.lineHeight = 1.0
        self.selectedTitleColor = UIColor.clear
        self.placeholderColor = UIColor(custom: .theme)
        self.textColor = UIColor(custom: .theme)
        self.font = UIFont.regular(ofSize: 15)
    }
}


class ThemeBlackTextField : SkyFloatingLabelTextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleColor = UIColor.clear
        self.selectedLineHeight = 0.0
        self.lineHeight = 0.0
        self.tintColor = UIColor.black
        self.selectedTitleColor = UIColor.clear
        self.placeholderColor = UIColor.gray
        self.textColor = UIColor.black
        self.font = UIFont.regular(ofSize: 18)
    
    }

}

class ThemeVehicleBlackTextField : SkyFloatingLabelTextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleColor = UIColor.clear
        self.selectedLineHeight = 0.0
        self.lineHeight = 0.0
        self.tintColor = UIColor.black
        self.selectedTitleColor = UIColor.clear
        self.placeholderColor = UIColor.black
        self.textColor = UIColor.black
        self.font = UIFont.regular(ofSize: 14)
    
    }

}

class ThemeTextField : UITextField
{
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont.regular(ofSize: 15)
        self.textColor = UIColor(custom: .theme)
    }
}




extension UITextField {
    var unwrappedText: String {
        (text ?? "").trimmed
    }

    var isEmpty: Bool {
        unwrappedText.isEmpty
    }
}
extension UITextView {
    var unwrappedText: String {
        (text ?? "").trimmed
    }
}

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
