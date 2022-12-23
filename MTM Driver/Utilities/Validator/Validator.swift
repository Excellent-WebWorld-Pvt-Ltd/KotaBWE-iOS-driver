//
//  Validator.swift
//  Peppea Passenger
//
//  Created by EWW-iMac Old on 26/06/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import UIKit

enum ValidatiionType{
    case email
    case isEmpty
    case numeric
    case password
    case isPhoneNumber
}

class Validator {
    static func validate(_ check: [(string: String?,errorString: String,type: ValidatiionType)]) -> Bool{
        for value in check{
            guard value.string != nil, value.string!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" else {
                AlertMessage.showMessageForError(value.errorString)
                return false
            }
            switch value.type{
                
            case .email:
                guard isEmail(string: value.string, errorString: value.errorString) else { return false }
            
            case .isEmpty:
                break
            
            case .numeric:
                guard isNumeric(string: value.string, errorString: value.errorString) else { return false }
            
            case .password:
                guard isPassword(string: value.string, errorString: value.errorString) else { return false }
          
            case .isPhoneNumber:
                guard isPhoneNumber(string: value.string, errorString: value.errorString) else { return false }
            }
        }
        return true
    }
    
    static private func isEmail(string: String?, errorString: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if !emailTest.evaluate(with: string){
            AlertMessage.showMessageForError(errorString)
            return false
        }
        return true
    }
   
    static private func isNumeric(string: String?, errorString: String) -> Bool{
        if string?.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil{
            AlertMessage.showMessageForError(errorString)
            return false
        }
         return true
    }
    
    static private func isPhoneNumber(string: String?, errorString: String) -> Bool{
        guard isNumeric(string: string, errorString: errorString) else { return false }
        if  string!.count < 9 {
            //string!.count > 10 ||
            AlertMessage.showMessageForError(errorString)
            return false
            }
        return true
        }
  
    static private func isPassword(string: String?, errorString: String) -> Bool{
        if string!.count < 6 {
            AlertMessage.showMessageForError(errorString)
            return false
        }
        return true
    }
    
    static private func emptyImage(string: String?, errorString: String) -> Bool{
        if string!.count < 6{
            AlertMessage.showMessageForError(errorString)
            return false
        }
        return true
    }
}
