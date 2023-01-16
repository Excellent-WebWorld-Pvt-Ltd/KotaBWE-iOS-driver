//
//  CustomOutlinedTxtField.swift
//  Danfo_Driver
//
//  Created by Sj's iMac on 07/04/21.
//

import UIKit
import MaterialComponents
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

//import MaterialComponents.MDCMultilineTextField


class CustomViewOutlinedTxtField: UIView {
    
    private var textFieldControllerFloating: MDCTextControl!
    var textField: MDCOutlinedTextField!
    var textF : MDCTextControl!

    @IBInspectable var placeHolder: String!
    @IBInspectable var labelText: String!
    @IBInspectable var primaryColor: UIColor! = .purple
    //@IBInspectable var IsWhiteTheme : Bool = false
    @IBInspectable var textFieldCorners: CGFloat = 15
    @IBInspectable var keyBoardType: UIKeyboardType = .default

    override open func draw(_ rect: CGRect) {
        super.draw(rect)

        textField.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)

    }
    open override func awakeFromNib() {
        super.awakeFromNib()
        setUpProperty()
    }
    
    func setUpProperty() {
        
        
        //Change this properties to change the propperties of text
         textField = MDCOutlinedTextField(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        textField.label.text = labelText
      
        textField.placeHolderColor = .themePlaceHolderGrey
        textField.leadingEdgePaddingOverride = 20
        textField.preferredContainerHeight = 40
        textField.setNormalLabelColor(.white, for: .editing)
        textField.setOutlineColor(.themeTextFieldDefaultBorderColor, for: .normal)
        textField.setOutlineColor(.themeTextFieldFilledBorderColor, for: .editing)
        textField.label.textColor = .themeTextBlackColor
        textField.placeholder = placeHolder
        textField.keyboardType = keyBoardType
        textField.setFloatingLabelColor(.themeTextFieldTitleColor, for: .editing)
        textField.setFloatingLabelColor(.themeTextFieldTitleColor, for: .normal)
        textField.setNormalLabelColor(.themeTextFieldTitleColor, for: .normal)
        textField.setNormalLabelColor(.themeTextFieldTitleColor, for: .editing)
        textField.setTextColor(.themeTextBlackColor, for: .editing)
        textField.setTextColor(.themeTextBlackColor, for: .normal)
        textField.font = FontBook.medium.font(ofSize: 16)
        textField.containerRadius = textFieldCorners
        textField.tintColor = .themeTextFieldFilledBorderColor
        textField.setLeadingAssistiveLabelColor(.red, for: .normal)
        textField.setLeadingAssistiveLabelColor(.red, for: .editing)
            //IsWhiteTheme == false ? UIColor.appColor(.themeGold):.white
         textField.sizeToFit()
        
        self.addSubview(textField)
    }

}

class CustomViewOutlinedTxtView: UIView {

    private var textFieldControllerFloating: MDCTextControl!
    var textArea: MDCOutlinedTextArea!

    var textF : MDCTextControl!

    @IBInspectable var placeHolder: String!
    @IBInspectable var labelText: String!
    @IBInspectable var primaryColor: UIColor! = .purple
    @IBInspectable var IsWhiteTheme : Bool = false
    @IBInspectable var textViewCorners: CGFloat = 15

    override open func draw(_ rect: CGRect) {
        super.draw(rect)

        textArea.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)

    }
    open override func awakeFromNib() {
        super.awakeFromNib()
        setUpProperty()
    }
    func setUpProperty() {
        //Change this properties to change the propperties of text
        textArea = MDCOutlinedTextArea(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        textArea.label.text = labelText
        textArea.leadingEdgePaddingOverride = 20
        textArea.preferredContainerHeight = 120
        // textField.placeHolderColor = IsWhiteTheme == false ?  UIColor.appColor(.themeGold) : UIColor.white
        textArea.textView.textColor = .themeTextBlackColor
        textArea.setNormalLabel(.white, for: .editing)
        textArea.setOutlineColor(.themeTextFieldDefaultBorderColor, for: .normal)
        textArea.setOutlineColor(.themeTextFieldFilledBorderColor, for: .editing)
        textArea.label.textColor = .themeTextBlackColor
        textArea.placeholder = placeHolder
        textArea.setFloatingLabel(.themeTextFieldTitleColor, for: .editing)
        textArea.setFloatingLabel(.themeTextFieldTitleColor, for: .normal)
        textArea.setNormalLabel(.themeTextFieldTitleColor, for: .normal)
        textArea.textView.font = FontBook.medium.font(ofSize: 16)
        
        textArea.setTextColor(.themeTextBlackColor, for: .editing)
        textArea.setTextColor(.themeTextBlackColor, for: .normal)
        
        textArea.leadingAssistiveLabel.font = FontBook.regular.font(ofSize: 12)
        textArea.setLeadingAssistiveLabel(.red, for: .normal)
        textArea.setLeadingAssistiveLabel(.red, for: .editing)
        
        textArea.tintColor = .themeTextFieldFilledBorderColor
        textArea.containerRadius = textViewCorners
        textArea.sizeToFit()
        
        self.addSubview(textArea)
    }
}
 
//class CustomViewOutlinedTxtView: UIView {
//
//    private var textFieldControllerFloating: MDCTextControl!
//    var textField: MDCOutlinedTextArea!
//
//    var textF : MDCTextControl!
//
//    @IBInspectable var placeHolder: String!
//    @IBInspectable var labelText: String!
//    @IBInspectable var primaryColor: UIColor! = .purple
//    @IBInspectable var IsWhiteTheme : Bool = false
//
//    override open func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        textField.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
//
//    }
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        setUpProperty()
//    }
//    func setUpProperty() {
//        //Change this properties to change the propperties of text
//        textField = MDCOutlinedTextArea(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
//        textField.label.text = labelText
//
//       // textField.placeHolderColor = IsWhiteTheme == false ?  UIColor.appColor(.themeGold) : UIColor.white
//        textField.textView.textColor = IsWhiteTheme == false ?  UIColor.appColor(.themeGold) : UIColor.white
//        textField.setNormalLabel(IsWhiteTheme == false ?  UIColor.appColor(.themeGold) : .white, for: .editing)
//        textField.setOutlineColor(IsWhiteTheme == false ?  UIColor.appColor(.themeGold) : .white, for: .normal)
//         textField.setOutlineColor(IsWhiteTheme == false ?  UIColor.appColor(.themeGold) : .white, for: .editing)
//        textField.label.textColor = IsWhiteTheme == false ?  UIColor.appColor(.themeGold) : .white
//        textField.placeholder = placeHolder
//        textField.setFloatingLabel(IsWhiteTheme == false ?  UIColor.appColor(.themeGold) : .white, for: .editing)
//        textField.setFloatingLabel(IsWhiteTheme == false ?  UIColor.appColor(.themeGold) : UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5), for: .normal)
//        textField.setNormalLabel(IsWhiteTheme == false ?  UIColor.appColor(.themeGold) :  UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5), for: .normal)
//        textField.textView.font = FontBook.regular.of(size: 17)
//
//        textField.setTextColor(IsWhiteTheme == false ?  UIColor.appColor(.themeGold) : UIColor.white, for: .editing)
//        textField.setTextColor(IsWhiteTheme == false ?  UIColor.appColor(.themeGold) : UIColor.white, for: .normal)
//        textField.tintColor = IsWhiteTheme == false ? UIColor.appColor(.themeGold):.white
//         textField.sizeToFit()
//
//        textField.sizeToFit()
//
//        self.addSubview(textField)
//    }

  

//}
