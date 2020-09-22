//
//  PriorityLimit+Meta.swift
//  Shortlist
//
//  Created by Mark Wong on 7/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

// MARK: - Collection View META DATA
enum PriorityLimitSection: Int, CaseIterable {
	case highPriority = 0
	case mediumPriority
	case lowPriority
	
	var value: String {
		switch self {
			case .highPriority:
				return "High Priority"
			case .mediumPriority:
				return "Medium Priority"
			case .lowPriority:
				return "Low Priority"
		}
	}
}

struct PriorityLimitItem: Hashable {
	var title: String
	var limit: Int
	var section: PriorityLimitSection
}
