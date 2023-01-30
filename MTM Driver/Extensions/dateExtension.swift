//
//  dateExtension.swift
//  DSP Driver
//
//  Created by Admin on 20/10/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation
import UIKit

enum DateFormatHelper: String {
    case standard       = "yyyy-MM-dd HH:mm:ss" //2020-02-17 16:42:37
    case fullDateTime   = "dd MMM yyyy, h:mm a" //12 Jan 2020, 5:15 pm
    case fullDate       = "dd MMM yyyy"
    case twentyHrTime   = "h:mma"
    //case dateformate   = "yyyy-MM-dd"
    case digitDate      = "yyyy-MM-dd" // 1992-07-07
    case TimeFormate =   "HH:mm:ss"
    case twelveHrTime   = "h:mm a"
    case dayDateMonth   = "E, d MMM" //Tue, 7 Sep 
    case slashDate      = "dd/MM/yyyy"
    case ddMMyyyy = "dd-MM-yyyy"
    case onlyNameOfDay = "EEEE"

    var dateFormatter: DateFormatter {
        let dateformat = DateFormatter()
        dateformat.dateFormat = self.rawValue
        return dateformat
    }

    func getDateString(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }

    func getDate(from string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
    
    func convert(to format: DateFormatHelper, string: String) -> String? {
        if let date = getDate(from: string) {
            return format.getDateString(from: date)
        } else {
            return nil
        }
    }
    
}

extension Date {
    
        var startOfWeek: Date {
            let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
            let dslTimeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: date)
            return date.addingTimeInterval(dslTimeOffset)
        }

        var endOfWeek: Date {
            return Calendar.current.date(byAdding: .second, value: 604799, to: self.startOfWeek)!
        }
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }

    func getDayDifferentTextWithTime() -> String {
        let calendar = Calendar.current
        let timeStr = DateFormatHelper.twelveHrTime.getDateString(from: self).lowercased()
        if calendar.isDateInToday(self) {
            return "Today, \(timeStr)"
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday, \(timeStr)"
        } else if calendar.isDateInTomorrow(self) {
            return "Tomorrow, \(timeStr)"
        } else {
            return DateFormatHelper.fullDateTime.getDateString(from: self)
        }
    }
    
    

    func getDayDifferentText() -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            return "Today"
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        } else if calendar.isDateInTomorrow(self) {
            return "Tomorrow"
        } else {
            return DateFormatHelper.fullDate.getDateString(from: self)
        }
    }
    
    var formattedDateStartWithDay: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatHelper.fullDate.rawValue
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
    
    var formattedDigitDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatHelper.digitDate.rawValue
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
    
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    var dayAfterWeek: Date {
        return Calendar.current.date(byAdding: .weekday, value: 1, to: self)!
    }
    
    var dayBeforeWeek: Date {
        return Calendar.current.date(byAdding: .weekday, value: -7, to: self)!
    }
    
    func getDateString(format: DateFormatHelper) -> String {
        return format.getDateString(from: self)
    }
}

extension String {
    func getDate(format: DateFormatHelper) -> Date? {
        format.getDate(from: self)
    }
}
