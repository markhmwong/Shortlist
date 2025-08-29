//
//  ReminderDatePickerViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 6/7/2025.
//  Copyright © 2025 Mark Wong. All rights reserved.
//

import Foundation

public class ReminderDatePickerViewModel {

	public let task: SLTask
	public var selectedDate: Date?
	// set the initial date to the current date
	public let initialDate: Date = Date()

	public init(task: SLTask, selectedDate: Date? = nil) {
		self.task = task
		self.selectedDate = selectedDate ?? Date()
	}

	public func updateReminderDate(_ date: Date) {
		self.task.reminder = date
	}
}
