//
//  Date+Extension.swift
//  Shortlist
//
//  Created by Mark Wong on 15/6/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

extension Date {
    
    static var today: Date {
        return Calendar.current.startOfDay(for: Date())
    }

    func todayFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
    
}
