//
//  SettingsKeys.swift
//  Shortlist
//
//  Created by Mark Wong on 16/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

struct SettingsKeyChainKeys {
    // Settings
	static let GlobalTasks: String = "GlobalTask"
	static let AllDayNotifications: String = "AllDay"
	
	// Priority Keys
    static let HighPriorityLimit: String = "HighPriorityLimit"
    static let MediumPriorityLimit: String = "MediumPriorityLimit"
    static let LowPriorityLimit: String = "LowPriorityLimit"

    // Review page Key
    static let ReviewDate: String = "ReviewDate"
}
