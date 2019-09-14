//
//  Int+Extension.swift
//  Five
//
//  Created by Mark Wong on 9/8/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

extension Int {
    func numberToWord() -> String {
        switch self {
        case 0:
            return "One"
        case 1:
            return "Two"
        case 2:
            return "Three"
        case 3:
            return "Four"
        case 4:
            return "Five"
        case 5:
            return "Six"
        case 6:
            return "Seven"
        case 7:
            return "Eight"
        case 8:
            return "Nine"
        case 9:
            return "Ten"
        case 10:
            return "Eleven"
        case 11:
            return "Twleve"
        case 12:
            return "Thirteen"
        case 13:
            return "Fourteen"
        case 14:
            return "Fiveteen"
        default:
            return "Task"
        }
    }
}
