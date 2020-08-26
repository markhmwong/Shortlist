//
//  AlarmCollectionView+Meta.swift
//  Shortlist
//
//  Created by Mark Wong on 25/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

struct AlarmItem: Hashable {
	var name: String
	var timeValue: Float
	var section: AlarmSection
}

enum AlarmSection: Int, CaseIterable {
	case Preset
	case Custom
	
	var stringValue: String {
		switch self {
			case .Custom:
				return "Custom"
			case .Preset:
				return "Preset"
		}
	}
}
