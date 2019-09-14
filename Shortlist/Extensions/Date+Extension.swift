//
//  Date+Extension.swift
//  Five
//
//  Created by Mark Wong on 23/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

extension Date {
    func toString(format: String = "dd-MM-YY") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension DateFormatter {
    
    // Local Time in UTC
    // https://stackoverflow.com/questions/50458685/swift-local-date-object-and-local-timezone
    func localDateTime() -> Date {
        self.dateFormat = "MM/dd/yy HH:mm:ss z"
        self.locale = Locale.current
        self.timeZone = TimeZone.current
        return date(from: string(from: Date())) ?? Date() //ugly conversion
    }
}
