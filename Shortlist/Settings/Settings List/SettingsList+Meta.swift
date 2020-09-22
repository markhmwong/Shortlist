//
//  SettingsList+Meta.swift
//  Shortlist
//
//  Created by Mark Wong on 3/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

struct SettingsListItem: Hashable {
	static func == (lhs: SettingsListItem, rhs: SettingsListItem) -> Bool {
		return lhs.id == rhs.id
	}
	
	var id: UUID = UUID()
	var title: String
	var subtitle: String?
	var section: SettingsListSection
	var icon: String
	
	var disclosure: Bool?
	var switchToggle: Bool?
	var item: SettingsListItems
	// cell type?
}

// The order of cases matters
enum SettingsListSection: Int, CaseIterable {
	case tip = 0
	case general
	case privacy
	case support
	case data
	
	
	var value: String {
		switch self {
			case .tip:
				return ""
			case .data:
				return "Data"
			case .general:
				return "General"
			case .support:
				return "Support"
			case .privacy:
				return "Privacy"
		}
	}
}

enum SettingsListItems: Int, CaseIterable {
	case priorityLimit
	case stats
	case tip
	case taskReview
	case review // app review, not task review
	case contact
	case privacy
	case permissions
	case whatsNew
	case appBiography
	case clearAllData
	case clearAllCategories
	case twitter
}
