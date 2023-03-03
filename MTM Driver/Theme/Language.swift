//
//  Language.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 19/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation

enum LanguageType: String{
    case english = "EN"
    case sawali = "SW"
    
    static var appLanguage: LanguageType{
        get{
            if UserDefaults.standard.value(forKey: "i18n_language") as? String == "sw"{
                return .sawali
            }
            return .english
        }
        set{
            switch newValue {
            case .sawali:
                UserDefaults.standard.set("sw", forKey: "i18n_language")
            default:
                UserDefaults.standard.set("en", forKey: "i18n_language")
            }
            UserDefaults.standard.synchronize()
        }
    }
}


extension String {
    var localized: String {
        let lang = UserDefaults.standard.string(forKey: LCLCurrentLanguageKey) ?? "en"
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        print(path ?? "")
        print(bundle ?? "")
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func encodeUTF8() -> String? {
        
        //If I can create an NSURL out of the string nothing is wrong with it
        if let _ = URL(string: self) {
            
            return self
        }
        
        //Get the last component from the string this will return subSequence
        let optionalLastComponent = self.split { $0 == "/" }.last
        
        
        if let lastComponent = optionalLastComponent {
            
            //Get the string from the sub sequence by mapping the characters to [String] then reduce the array to String
            let lastComponentAsString = lastComponent.map { String($0) }.reduce("", +)
            
            
            //Get the range of the last component
            if let rangeOfLastComponent = self.range(of: lastComponentAsString) {
                //Get the string without its last component
                let stringWithoutLastComponent = self.substring(to: rangeOfLastComponent.lowerBound)
                
                
                //Encode the last component
                if let lastComponentEncoded = lastComponentAsString.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) {
                    
                    
                    //Finally append the original string (without its last component) to the encoded part (encoded last component)
                    let encodedString = stringWithoutLastComponent + lastComponentEncoded
                    
                    //Return the string (original string/encoded string)
                    return encodedString
                }
            }
        }
        
        return nil;
    }
    
    
    func htmlDecoded()->String {
        
        guard (self != "") else { return self }
        
        var newStr = self
        
        let entities = [
            "&quot;"    : "\"",
            "&ldquo;"   : "\"",
            "&amp;"     : "&",
            "&apos;"    : "'",
            "&lt;"      : "<",
            "&gt;"      : ">",
            "&nbsp;"    : "\n",
            
            
            
            ]
        
        for (name,value) in entities {
            newStr = newStr.replacingOccurrences(of: name, with: value)
        }
        return newStr
    }
    
    
    
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: NSCharacterSet.decimalDigits.inverted) == nil
            
        }
    }
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern:"[A-Z0-9a-z._%+-]{2,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    
    //validate PhoneNumber
    var isPhoneNumber: Bool {
        
        let charcter  = CharacterSet(charactersIn: "+0123456789").inverted
        var filtered:String!
        
        let inputString:[String] = self.components(separatedBy: charcter)
        filtered = inputString.joined(separator: "") as String
        return  self == filtered
        
    }
    
    
    
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ssZ")-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
        
    }
}


