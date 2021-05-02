//
//  PriorityLevel.swift
//  Shortlist
//
//  Created by Mark Wong on 18/12/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

// A enumeration of priority levels available for the user to select

enum Priority: Int16, CaseIterable {
	case high = 0 // pressing priority
	case medium //doable
	case low // touchandgo priority
    // case flash
	case none
	
	init() {
		self = .medium
	}
	
	var value: Int16 {
		switch self {
			case .high:
				return Priority.high.rawValue
			case .medium:
				return Priority.medium.rawValue
			case .low:
				return Priority.low.rawValue
			case .none:
				return Priority.none.rawValue
		}
	}
	
	var stringValue: String {
		switch self {
			case .high:
				return "High"
			case .medium:
				return "Medium"
			case .low:
				return "Low"
			case .none:
				return "None"
		}
	}
	
	var color: UIColor {
		switch self {
			case .high:
				return ThemeV2.Priority.highColor
			case .medium:
				return ThemeV2.Priority.mediumColor
			case .low:
				return ThemeV2.Priority.lowColor
			case .none:
				return ThemeV2.Priority.noneColor
		}
	}
	
}
