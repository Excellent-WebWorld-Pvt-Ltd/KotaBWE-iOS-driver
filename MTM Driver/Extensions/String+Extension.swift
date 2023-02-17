//
//  String+Extension.swift
//  DPS
//
//  Created by Gaurang on 28/09/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import UIKit

extension Double {
    func toCurrencyString() -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        //currencyFormatter.locale = Locale(identifier: "en_KE")
        currencyFormatter.currencySymbol = Currency
//        currencyFormatter.minimumFractionDigits = 0
//        currencyFormatter.maximumFractionDigits = 2
        let priceString = currencyFormatter.string(from: NSNumber(value: self))!
        return priceString
    }
}

extension Int {
    func secondsToTimeFormate() -> String? {
        let seconds = self
        if seconds < 60 {
            return "\(seconds)s"
        }
        let minutes = seconds / 60
        if minutes < 60 {
            let restSeconds = seconds % 60
            return "\(minutes)m \(restSeconds)s"
        }
        let hours = minutes / 60
        let restMinutes = minutes % 60
        return "\(hours)h \(restMinutes)m"
    }
    func secondsToTimeFormat() -> String? {
            let seconds = self
            if seconds < 60 {
                if seconds < 10 {
                    return "00m 0\(seconds)s"
                }else{
                    return "00m \(seconds)s"
                }
            }
            let minutes = seconds / 60
            if minutes < 60 {
                let restSeconds = seconds % 60
                if minutes < 10 {
                    return "0\(minutes)m \(restSeconds)s"
                }else{
                    return "\(minutes)m \(restSeconds)s"
                }
            }
            let hours = minutes / 60
            let restMinutes = minutes % 60
            return "\(hours)h \(restMinutes)m"
        }
}

extension String {
    func toCurrencyString() -> String {
        return "\(Currency) \(self)"//Double(self)?.toCurrencyString() ?? ""
    }

    var nsRange : NSRange {
        return NSRange(self.startIndex..., in: self)
    }

    func nsRange(of string: String) -> NSRange {
        return (self as NSString).range(of: string)
    }

    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isNotEmpty: Bool {
        self.trimmed.isEmpty == false
    }

    func convertToUnderLineAttributedString(font: UIFont, color: UIColor) -> NSAttributedString {
        let attr: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        return NSAttributedString(string: self, attributes: attr)
    }

    func secondsToTimeFormate() -> String? {
        Int(self)?.secondsToTimeFormate()
    }

    func toTimeFormate() -> String? {
        guard let minutes = Int(self) else {
            return nil
        }
        if minutes < 60 {
            return "\(minutes) Min"
        } else {
            let hr = minutes / 60
            let restMinutes = minutes % 60
            return "\(hr)Hr \(restMinutes)Min"
        }
    }

    func toImageUrl() -> String {
        NetworkEnvironment.baseImageURL + self
    }

    func timeStampToDate() -> Date? {
        guard let doubleValue = Double(self) else {
            return nil
        }
        return Date(timeIntervalSince1970: doubleValue)
    }

    func toDistanceString() -> String {
        guard let doubleValue = Double(self) else {
            return self
        }
        if doubleValue >= 2 {
            return "\(doubleValue) KMS"
        } else {
            return "\(doubleValue) KM"
        }
    }
    
    func convertDateString(inputFormat: DateFormatHelper, outputFormat: DateFormatHelper) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = inputFormat.rawValue
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = outputFormat.rawValue
            return  dateFormatter.string(from: date)
        }else{
            print("Could not get the dat string from dateformattere")
            return ""
        }
    }
    
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }

    
}

extension Array {
    var isNotEmpty: Bool {
        return count > 0
    }
}
