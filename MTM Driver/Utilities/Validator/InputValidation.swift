//
//  InputValidation.swift
//  InputValidation
//
//  Created by Gaurang on 17/02/22.
//

import Foundation
import UIKit

typealias ValidationResult = (isValid: Bool, error: String?)

enum InputValidation {
    case email
    case password
    case mobile
    case name
    case nonEmpty
    case username
    case bankaccount
}

extension InputValidation {

    var maxLimit: Int {
        switch self {
        case .mobile:   return 9
        case .name:     return 25
        case .password: return 25
        case .bankaccount: return 10
        default:        return 200
        }
    }
    
    var allowedCharacters: String{
        switch self {
        case .email:
            return "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#$%&'*+-/=?^_`{|}~;@."
        case .mobile:
            return "0123456789"
        case .bankaccount:
            return "0123456789"
        case .name:
            return "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        default:
            return ""
        }
    }

    var pattern: String {
        switch self {
        case .email:
            return "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
        case .username:
            return "^\\w{7,18}$"
        case .password:
            return "[a-zA-Z0-9!@#$%^&*]{8,25}"
            // [a-zA-Z0-9!@#$%^&*]
          //  return "(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,15}"
        case .mobile:
            return "[0-9]{9}"
        case .bankaccount:
            return "[0-9]{9,12}"
        case .name:
            return "[A-Za-z]{2,25}"
        case .nonEmpty:
            return ""
        }
    }

    func isValid(input: String, field: String) -> ValidationResult {
        switch self {
        case .email:
            return validateEmail(input: input, field: field)
        case .password:
            return validatePassword(input: input, field: field)
        case .mobile:
            return validateMobile(input: input, field: field)
        case .bankaccount:
            return validateMobile(input: input, field: field)
        case .name:
            return validateName(input: input, field: field)
        case .nonEmpty:
            return validateNoEmpty(input: input, field: field)
        case .username:
            return validateUsername(input: input, field: field)
        }
    }

    func isValidForPattern(input: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", self.pattern)
        return predicate.evaluate(with: input)
    }
}

class BunchEmptyValidator {
    private var inputArray: [(input: String, message: String)] = []
    
    func append(input: String?, message: String) {
        inputArray.append((input ?? "", message))
    }
    
    func validate() -> ValidationResult {
        for item in inputArray {
            if item.input.isEmpty {
                return (false, item.message)
            }
        }
        return (true, nil)
    }
    
}

// MARK: - Validation Methods
extension InputValidation {
    
    // MARK: - None Empty
    func validateNoEmpty(input: String, field: String) -> ValidationResult {
        if input.isEmpty {
            return (false, "\(Messages.pleaseEnter.localized) \(field)")
        } else {
            return (true, nil)
        }
    }
    
    // MARK: - Name
    func validateName(input: String, field: String) -> ValidationResult {
        let emptyValidation = validateNoEmpty(input: input, field: field)
        guard emptyValidation.isValid else {
            return emptyValidation
        }
        guard input.count > 1 else {
            return (false, "\("Please enter minimum 2 characters in".localized) \(field).")
        }
        guard isValidForPattern(input: input) else {
            return (false, "\(Messages.pleaseEnterValid.localized) \(field)")
        }
        return (true, nil)
    }
    
    // MARK: - Email
    func validateEmail(input: String, field: String) -> ValidationResult {
        let emptyValidation = validateNoEmpty(input: input, field: field)
        guard emptyValidation.isValid else {
            return emptyValidation
        }
        guard isValidForPattern(input: input) else {
            return (false, "\(Messages.pleaseEnterValid.localized) \(field)")
        }
        return (true, nil)
    }
    
    // MARK: - Mobile
    func validateMobile(input: String, field: String) -> ValidationResult {
        let emptyValidation = validateNoEmpty(input: input, field: field)
        guard emptyValidation.isValid else {
            return emptyValidation
        }
        guard isValidForPattern(input: input) else {
            return (false, "\(Messages.pleaseEnterValid.localized) \(field)")
        }
        return (true, nil)
    }
    // MARK: - account
    func validateAccount(input: String, field: String) -> ValidationResult {
        let emptyValidation = validateNoEmpty(input: input, field: field)
        guard emptyValidation.isValid else {
            return emptyValidation
        }
        guard isValidForPattern(input: input) else {
            return (false, "\(Messages.pleaseEnterValid.localized) \(field)")
        }
        return (true, nil)
    }
    
    // MARK: - UserName
    func validateUsername(input: String, field: String) -> ValidationResult {
        let emptyValidation = validateNoEmpty(input: input, field: field)
        guard emptyValidation.isValid else {
            return emptyValidation
        }
        guard input.count >= 7 && input.count <= 18 else {
            return (false, Messages.invalidUsernameRange.localized)
        }
        guard isValidForPattern(input: input) else {
            return (false, "\(Messages.specialCharacterNotAllowed.localized) \(field)")
        }
        return (true, nil)
    }
    
    // MARK: - Password
    func validatePassword(input: String, field: String) -> ValidationResult {
        let emptyValidation = validateNoEmpty(input: input, field: field)
        guard emptyValidation.isValid else {
            return emptyValidation
        }
        guard input.count >= 8 && input.count <= 25 else {
            return (false, Messages.invalidPasswordRange.localized)
        }
        
        guard isValidForPattern(input: input) else {
            return (false, "\(Messages.pleaseEnterValid.localized) \(field)")
        }
        return (true, nil)
    }
}

extension InputValidation {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = textField.text! as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        var isValid = newString.length <= self.maxLimit
        let characters = self.allowedCharacters
        if isValid && characters.isEmpty == false {
            let allowedCharacters = CharacterSet(charactersIn:characters)
            let characterSet = CharacterSet(charactersIn: string)
            isValid = allowedCharacters.isSuperset(of: characterSet)
        }
        return isValid
    }
}

enum Messages {
    static let pleaseEnter = "Please enter"
    static let pleaseEnterValid = "Please enter valid"
    static let specialCharacterNotAllowed = "Special characters are not allowed in"
    static let invalidUsernameRange = "Username must be between 8 to 18 characters"
    static let invalidPasswordRange = "Password must be between 8 to 25 characters"
    static let cameraAccess = "Unable to access the Camera"
    static let cameraAccessMsg = "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app."
    static let photoAccess = "Unable to access the Photos"
    static let photoAccessMsg = "To enable access, go to Settings > Privacy > Photos and turn on Photos access for this app."
    static let chooseSource = "Choose A Source"

    static let emptyDriverLicenseFront = "Please select driver's license front"
    static let emptyDriverLicenseBack = "Please select driver's license back"
    static let emptyCriminalRecord = "Please select Criminal record"
    static let emptyResidenceCertificate = "Please select Residence certificate"
    static let emptyRentalLicense = "Please select Rental license"
    static let emptyBooklet = "Please select Booklet"
    static let emptyCivilLiabilityInsurance = "Please select Civil liability insurance"
    static let emptyBIFront = "Please select BI front"
    static let emptyBIBack = "Please select BI back"

    static let emptyDriverLicenseExpire = "Please enter driver's license expiry date"
    static let emptyRentalLicenseExpire = "Please enter Rental license expiry date"
    static let emptyCivilLiabilityInsuranceExpire = "Please enter Civil liability insurance expiry date"
    static let emptyBIExpire = "Please enter BI expiry date"
}
