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
}

extension InputValidation {

    var maxLimit: Int {
        switch self {
        case .mobile:   return 12
        case .name:     return 25
        case .password: return 15
        default:        return 200
        }
    }
    
    var allowedCharacters: String{
        switch self {
        case .email:
            return "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#$%&'*+-/=?^_`{|}~;@."
        case .mobile:
            return "0123456789"
        default:
            return ""
        }
    }

    var pattern: String {
        switch self {
        case .email:
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,15}"
        case .username:
            return "^\\w{7,18}$"
        case .password:
            return "[a-zA-Z0-9!@#$%^&*]{8,15}"
            // [a-zA-Z0-9!@#$%^&*]
          //  return "(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,15}"
        case .mobile:
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
            return (false, "\(Messages.pleaseEnter) \(field)")
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
            return (false, "Please enter minimum 2 characters in \(field).")
        }
        guard isValidForPattern(input: input) else {
            return (false, "\(Messages.pleaseEnterValid) \(field)")
        }
        return (true, "")
    }
    
    // MARK: - Email
    func validateEmail(input: String, field: String) -> ValidationResult {
        let emptyValidation = validateNoEmpty(input: input, field: field)
        guard emptyValidation.isValid else {
            return emptyValidation
        }
        guard isValidForPattern(input: input) else {
            return (false, "\(Messages.pleaseEnterValid) \(field)")
        }
        return (true, "")
    }
    
    // MARK: - Mobile
    func validateMobile(input: String, field: String) -> ValidationResult {
        let emptyValidation = validateNoEmpty(input: input, field: field)
        guard emptyValidation.isValid else {
            return emptyValidation
        }
        guard isValidForPattern(input: input) else {
            return (false, "\(Messages.pleaseEnterValid) \(field)")
        }
        return (true, "")
    }
    
    // MARK: - UserName
    func validateUsername(input: String, field: String) -> ValidationResult {
        let emptyValidation = validateNoEmpty(input: input, field: field)
        guard emptyValidation.isValid else {
            return emptyValidation
        }
        guard input.count >= 7 && input.count <= 18 else {
            return (false, Messages.invalidUsernameRange)
        }
        guard isValidForPattern(input: input) else {
            return (false, "\(Messages.specialCharacterNotAllowed) \(field)")
        }
        return (true, "")
    }
    
    // MARK: - Password
    func validatePassword(input: String, field: String) -> ValidationResult {
        let emptyValidation = validateNoEmpty(input: input, field: field)
        guard emptyValidation.isValid else {
            return emptyValidation
        }
        guard input.count >= 8 && input.count <= 25 else {
            return (false, Messages.invalidPasswordRange)
        }
        
        guard isValidForPattern(input: input) else {
            return (false, "\(Messages.pleaseEnterValid) \(field)")
        }
        return (true, "")
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
    static let pleaseEnter = "Please Enter"
    static let pleaseEnterValid = "Please Enter valid"
    static let specialCharacterNotAllowed = "Special characters are not allowed in"
    static let invalidUsernameRange = "Username must be between 8 and 18 characters"
    static let invalidPasswordRange = "Password must be between 8 and 25 characters"
    static let cameraAccess = "Unable to access the Camera"
    static let cameraAccessMsg = "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app."
    static let photoAccess = "Unable to access the Photos"
    static let photoAccessMsg = "To enable access, go to Settings > Privacy > Photos and turn on Photos access for this app."
    static let chooseSource = "Choose A Source"

    static let emptyNationalCard = "Please select national id card"
    static let emptyNationalId = "Please enter national ID card number"
    static let emptyDriverLicense = "Please select driver's license"
    static let emptyDriverPSVLicense = "Please select driver PSV license"
    static let emptyGoodConductCertificate = "Please select good conduct certificate / Police clearance"
    static let emptyVehiclePSVLicense = "Please select vehicle PSV license"
    static let emptyVehicleLogbook = "Please select vehicle logbook"
    static let emptyNTSAInspectionCert = "Please select NTSA Inspection certificate"
    static let emptyPSVComprehensiveInsurance = "Please select PSV comprehensive insurance"

    static let emptyDriverLicenseExpire = "Please enter driver's license expiry date"
    static let emptyDriverPSVLicenseExpire = "Please enter driver PSV license expiry date"
    static let emptyVehiclePSVLicenseExpire = "Please enter vehicle PSV license expiry date"
    static let emptyNTSAInspectionCertExpire = "Please enter NTSA Inspection certificate expiry date"
    static let emptyPSVComprehensiveInsuranceExpire = "Please enter PSV comprehensive insurance expiry date"
    
}
