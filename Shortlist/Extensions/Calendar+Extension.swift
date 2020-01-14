//
//  Calendar+Extension.swift
//  Five
//
//  Created by Mark Wong on 22/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

// If you forget, call as Calendar.current.myFunction
extension Calendar {
    
    //deprecated, please use the DateFormatter extension
    func today() -> Date {
        return self.startOfDay(for: Date())
    }
	
	// 0 - today, negatives go back in time as expected
	func forSpecifiedDay(value: Int) -> Date {
		return self.startOfDay(for: Calendar.current.date(byAdding: .day, value: value, to: self.today())!)
	}
    
    func yesterday() -> Date {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: self.today())
        return yesterday!
    }
    
    func sevenDaysFromDate(currDate: Date) -> Date {
        let date = Calendar.current.date(byAdding: .day, value: Int(-6), to: currDate)
        return date!
    }
    
    func sevenDaysFromToday() -> Date {
        let date = Calendar.current.date(byAdding: .day, value: Int(-7), to: self.today())
        return date!
    }
    
    func thirtyDaysFromToday() -> Date {
        let date = Calendar.current.date(byAdding: .day, value: Int(-29), to: self.today())
        return date!
    }
    
    // Week starts on Sunday
    func startOfWeek() -> Date {
        let today = todayToInt() - 1 // -1 for including today
        if today > 0 {
            let date = Calendar.current.date(byAdding: .day, value: Int(-today), to: self.today())
            return date!
        } else {
            return self.today()
        }
    }
    
    // Returns an int that relates to the day of the week - Sunday = 1, monday, tuesday, wednesday.
    func dayOfWeek(date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday!
    }
    
    func dayDate(date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return components.day!
    }
    
    
    func todayToInt() -> Int16 {
        let today = Calendar.current.date(byAdding: .day, value: 0, to: self.today())
        return Int16(Calendar.current.component(.weekday, from: today!))
    }
    
    func monthToInt() -> Int16 {
        let today = Calendar.current.date(byAdding: .day, value: 0, to: self.today())
        return Int16(Calendar.current.component(.month, from: today!))
    }
    
    func yearToInt() -> Int16 {
        let today = Calendar.current.date(byAdding: .day, value: 0, to: self.today())
        return Int16(Calendar.current.component(.year, from: today!))
    }
    
    func monthToInt(date: Date, adjust: Int) -> Int16 {
        let today = Calendar.current.date(byAdding: .day, value: 0, to: date)
        return Int16(Calendar.current.component(.month, from: today!))
    }
    
    func daysInMonth() -> Int {
        let month = self.monthToInt()
        let year = self.yearToInt()
        
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(calendar: nil, timeZone: nil, era: nil, year: Int(year), month: Int(month), day: nil, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil))!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
}

enum DayOfWeek: Int16 {
    case Sunday = 1
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    
    var shortHand: String {
        switch self {
        case .Sunday:
            return "S"
        case .Monday:
            return "M"
        case .Tuesday:
            return "T"
        case .Wednesday:
            return "W"
        case .Thursday:
            return "T"
        case .Friday:
            return "F"
        case .Saturday:
            return "S"
        }
    }
}

enum MonthType: Int16 {
    case January = 0
    case February
    case March
    case April
    case May
    case June
    case July
    case August
    case September
    case October
    case November
    case December
}
