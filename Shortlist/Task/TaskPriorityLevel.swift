//
//  PriorityLevel.swift
//  Shortlist
//
//  Created by Mark Wong on 29/6/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

enum TaskPriorityLevel: Int, CaseIterable {
	case critical
	case high
    case medium
    case low
    
    var baseColour: UIColor {
        switch self {
		case .critical:
			return UIColor.criticalPriority
        case .high:
            return UIColor.highPriority
        case .medium:
            return UIColor.mediumPriority
        case .low:
            return UIColor.lowPriority
        }
    }
}
