//
//  PriorityLevel.swift
//  Shortlist
//
//  Created by Mark Wong on 18/12/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

// A enumeration of priority levels available for the user to select

enum Priority: Int16 {
	case high = 0 // pressing priority
	case medium //doable
	case low // touchandgo priority
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
	
}
