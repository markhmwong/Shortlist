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
