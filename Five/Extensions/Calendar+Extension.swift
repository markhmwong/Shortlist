//
//  Calendar+Extension.swift
//  Five
//
//  Created by Mark Wong on 22/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

extension Calendar {
    func today() -> Date {
        return self.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
    }
    
    func yesterday() -> Date {
        let today = self.today()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)
        return yesterday!
    }
}
