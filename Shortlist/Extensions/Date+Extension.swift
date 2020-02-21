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
	
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
	
	func hoursRemaining() -> Int {
		let tomorrow = Calendar.current.forSpecifiedDay(value: 1)
		let now = Date()
		let diff = tomorrow.timeIntervalSince(now)
		return Int(diff) / 3600
	}
	
	func timeRemainingToHour() -> TimeInterval {
		let tomorrow = Calendar.current.forSpecifiedDay(value: 1)
		let now = Date()
		let diff = tomorrow.timeIntervalSince(now)
		return diff.truncatingRemainder(dividingBy: 3600) / 60
	}
	
	// time in hour and minute
	func timeToString(format: String = "HH:mm") -> String {
		let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
		dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
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
