//
//  SettingsTaskListItem.swift
//  Shortlist
//
//  Created by Mark Wong on 11/12/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//
import UIKit

struct SettingsTaskLimitItem: SettingsItemProtocol {
	var id: UUID = UUID()
	var title: String
	var section: SettingsViewModel.SettingsSection
	var value: String?
	var itemType: SettingsCellType
	var performAction: (() -> ())?

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(title)
		hasher.combine(value)
	}

	static func == (lhs: SettingsTaskLimitItem, rhs: SettingsTaskLimitItem) -> Bool {
		return lhs.id == rhs.id &&
		lhs.title == rhs.title &&
		lhs.value == rhs.value
	}

}
