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
	var timeValue: Int? // Use to determine the preset value by math (timeValue / 60) / 5
	var isAllDay: Bool?
	var isCustom: Bool? // custom timer
	var isPreset: Bool?
	var presetType: Int? // The approach is a bit confusing. If presetType is not nil, then it's selected.
	var reminder: Date?
}

// -1 preset is disabled
enum PresetType: Int, CaseIterable {
	case minutes5 = 1
	case minutes10
	case minutes15
	case minutes20
	case minutes25
	case minutes30
	case minutes35
	case minutes40
	case minutes45
	case minutes50
	case minutes55
	
	static func secondsToType(seconds: Int) -> PresetType {
		let type = (seconds / 60) / 5
		return PresetType.init(rawValue: type) ?? .minutes5
	}
	
	func typeToSeconds() -> Int {
		return self.rawValue * 60 * 5
	}
	
}

enum AlarmSection: Int, CaseIterable {
	case Enabled
	case Reminder
	case AllDay
	case Custom
	case Preset
	
	var headerTitle: String {
		switch self {
			case .Reminder:
				return ""
			case .Enabled:
				return "Reminder"
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
			case .Reminder:
				return ""
			case .Enabled:
				return "Turn the Reminder on to see additional options"
			case .AllDay:
				return "An hourly reminder, that will repeat until the end of the day i.e. 12pm, 1pm, 2pm until the end of the day. This overrides all timers."
			case .Custom:
				return "Set a one off reminder at a specific time during today."
			case .Preset:
				return "A list of preset timers, set a one off reminder in n minutes from the current time."
		}
	}
}
