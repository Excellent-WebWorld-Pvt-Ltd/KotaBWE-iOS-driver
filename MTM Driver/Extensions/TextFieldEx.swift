//
//  TextFieldEx.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 01/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

extension UITextField{
    func setRightViewImage(name: String, mode: UITextField.ViewMode){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 6, width: 10, height: 10))
        imageView.image = UIImage(named: name)
        self.rightView = imageView
        self.rightViewMode = mode
    }
}

extension UITextView {
    
    func getText() -> String {
        return text.trimmed
    }
    
    var isEmpty: Bool {
        return getText().isEmpty
    }
}
