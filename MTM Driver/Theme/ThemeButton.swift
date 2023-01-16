//
//  ThemeButton.swift
//  Pappea Driver
//
//  Created by Mayur iMac on 09/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class ThemePlainButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        titleLabel?.font = UIFont.semiBold(ofSize: 16.0)
        setTitleColor(.black, for: .normal)
    }
}

class ThemeButton: UIButton {

    @IBInspectable var isSubmit : Bool = false
    @IBInspectable var blueBold: Bool = false

    
    override func awakeFromNib() {
        super.awakeFromNib()
        var attr: [NSAttributedString.Key: Any] = [:]

        if isSubmit == true {
            self.titleLabel?.font = UIFont.bold(ofSize: 14.0)
            self.backgroundColor = UIColor.themeColor
            self.layer.cornerRadius = self.frame.height/2
            self.clipsToBounds  = true
        }
        else if blueBold == true {
            attr[.font] = FontBook.bold.font(ofSize: 16)
            attr[.foregroundColor] = UIColor.hexStringToUIColor(hex:"2680EB")
            attr[.underlineStyle] = NSUnderlineStyle.single.rawValue
            let attrStr = NSAttributedString(string: self.title(for: .normal) ?? "", attributes: attr)
            setAttributedTitle(attrStr, for: .normal)
        }
        else {
            self.titleLabel?.font = UIFont.regular(ofSize: 16)
            self.backgroundColor = UIColor(custom: .theme)
        }
        
//        self.setTitleColor(UIColor(custom: .textWhite), for: .normal)
    }
}

class UnderlineTextButton: UIButton {

    override func setTitle(_ title: String?, for state: UIControl.State) {
    super.setTitle(title, for: .normal)
    self.setAttributedTitle(self.attributedString(), for: .normal)
}

private func attributedString() -> NSAttributedString? {
    let attributes : [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font : UIFont.regular(ofSize: 15.0),
        NSAttributedString.Key.foregroundColor : UIColor.red,
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
    ]
    let attributedString = NSAttributedString(string: self.currentTitle!, attributes: attributes)
    return attributedString
  }
}

extension NSMutableAttributedString {
 @discardableResult func bold(_ text:String) -> NSMutableAttributedString {

    let attrs : [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font : UIFont.bold(ofSize: 14.0),
        NSAttributedString.Key.foregroundColor : UIColor.black,
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
    let boldString = NSMutableAttributedString(string: text, attributes: attrs)
    self.append(boldString)
    return self
 }
    
    @discardableResult func boldWithOpacity60(_ text:String) -> NSMutableAttributedString {

       let attrs : [NSAttributedString.Key : Any] = [
           NSAttributedString.Key.font : UIFont.bold(ofSize: 14.0),
           NSAttributedString.Key.foregroundColor : UIColor.black.withAlphaComponent(0.6),
           NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
       let boldString = NSMutableAttributedString(string: text, attributes: attrs)
       self.append(boldString)
       return self
    }
    
    @discardableResult func bold14(_ text:String) -> NSMutableAttributedString {

       let attrs : [NSAttributedString.Key : Any] = [
           NSAttributedString.Key.font : UIFont.bold(ofSize: 14.0),
           NSAttributedString.Key.foregroundColor : UIColor.themeColor,
           NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
       let boldString = NSMutableAttributedString(string: text, attributes: attrs)
       self.append(boldString)
       return self
    }
    @discardableResult func Semibold(_ text:String) -> NSMutableAttributedString {

       let attrs : [NSAttributedString.Key : Any] = [
           NSAttributedString.Key.font : UIFont.semiBold(ofSize: 14.0),
        NSAttributedString.Key.foregroundColor : UIColor.hexStringToUIColor(hex: "#7D7D7D").withAlphaComponent(0.7),
           NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
       let boldString = NSMutableAttributedString(string: text, attributes: attrs)
       self.append(boldString)
       return self
    }
    
    @discardableResult func medium(_ text:String) -> NSMutableAttributedString {

       let attrs : [NSAttributedString.Key : Any] = [
           NSAttributedString.Key.font : UIFont.medium(ofSize: 14.0),
        NSAttributedString.Key.foregroundColor : UIColor.hexStringToUIColor(hex: "#18022E"),
           NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
       let boldString = NSMutableAttributedString(string: text, attributes: attrs)
       self.append(boldString)
       return self
    }

    @discardableResult func normal(_ text:String , Colour:UIColor , _ size:CGFloat = 18.0)->NSMutableAttributedString {
        let attrs : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.medium(ofSize: size),
            NSAttributedString.Key.foregroundColor : Colour
        ]
        let normal =  NSAttributedString(string: text,  attributes:attrs)
        self.append(normal)
        return self
    }
    
    @discardableResult func regular(_ text:String , Colour:UIColor , _ size:CGFloat = 18.0)->NSMutableAttributedString {
        let attrs : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.regular(ofSize: size),
            NSAttributedString.Key.foregroundColor : Colour
        ]
        let normal =  NSAttributedString(string: text,  attributes:attrs)
        self.append(normal)
        return self
    }
}

extension UIButton {
    func underline() {
        setUnderline(for: .normal)
        setUnderline(for: .disabled)
    }
    
    func setUnderline(for state: UIControl.State) {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: state)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: state)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: state)
    }
}
