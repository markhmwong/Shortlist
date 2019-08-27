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
    func today() -> Date {
        return self.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
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
    
    func yesterday() -> Date {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: self.today())
        return yesterday!
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
}

enum DayOfWeek: Int16 {
    case Sunday = 1
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
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
