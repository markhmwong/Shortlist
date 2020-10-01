//
//  AlarmCollectionView+Meta.swift
//  Shortlist
//
//  Created by Mark Wong on 25/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

struct AlarmItem: Hashable {
	var id: UUID = UUID()
	var title: String
	var section: AlarmSection
	var timeValue: Float?
	var isAllDay: Bool?
	var isCustom: Bool? // custom timer
}

enum AlarmSection: Int, CaseIterable {
	case AllDay
	case Custom
	case Preset
	
	var headerTitle: String {
		switch self {
			case .AllDay:
				return "Repeat all day"
			case .Custom:
				return "Custom"
			case .Preset:
				return "Preset"
		}
	}
	
	var footerDescription: String {
		switch self {
			case .AllDay:
				return "An hourly reminder, that will repeat until the end of the day i.e. 12pm, 1pm, 2pm until the end of the day. This overrides all timers."
			case .Custom:
				return "Set a one off reminder at a specific time during today."
			case .Preset:
				return "A list of preset timers, set a one off reminder in n minutes from the current time."
		}
	}
}
