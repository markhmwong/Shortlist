//
//  TaskReminder+Extension.swift
//  Shortlist
//
//  Created by Mark Wong on 15/10/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

extension TaskReminder {
	
	func resetReminder() {
		self.isCustom = false
		self.isPreset = false
		self.presetType = 0
		self.reminderId = ""
		self.reminder = nil
	}
	
}
