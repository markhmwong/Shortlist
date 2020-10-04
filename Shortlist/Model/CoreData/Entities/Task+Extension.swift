//
//  File.swift
//  Shortlist
//
//  Created by Mark Wong on 19/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import CoreData
import EventKit


extension Task {
	/*
	
		MARK: - Unit Test Functions
	
	*/
	
	func nameLengthRestriction() -> Bool {
		let count = self.name?.count ?? 0
		if (count >= TaskCharacterLimits.taskNameMinimumCharacterLimit && count <= TaskCharacterLimits.taskNameMaximumCharacterLimit) {
			return true
		} else if (count < TaskCharacterLimits.taskNameMinimumCharacterLimit || count > TaskCharacterLimits.taskNameMaximumCharacterLimit) {
			return false
		}
		return false
	}
	
	func detailsLengthRestriction() -> Bool {
		// details limit should be discovered first
		
		let count = self.details?.count ?? 0
		if (count >= TaskCharacterLimits.taskDetailsMinimumCharacterLimit && count <= TaskCharacterLimits.taskDetailsMaximumCharacterLimit) {
			return true
		} else if (count < TaskCharacterLimits.taskDetailsMinimumCharacterLimit || count > TaskCharacterLimits.taskDetailsMaximumCharacterLimit) {
			return false
		}
		return false
	}
	
	func categoryLengthRestriction() -> Bool {
		let count = self.category?.count ?? 0
		
		if (count >= TaskCharacterLimits.taskCategoryMinimumCharacterLimit && count <= TaskCharacterLimits.taskCategoryMaximumCharacterLimit) {
			return true
		} else if (count < TaskCharacterLimits.taskCategoryMinimumCharacterLimit || count > TaskCharacterLimits.taskCategoryMaximumCharacterLimit) {
			return false
		}
		
		return false
	}
	
	/*
	
		MARK: - Methods that shouldn't be altered between Core Data Versions
	
	*/
	
	func fillTaskWithSampleData() {
		self.carryOver = false
		self.category = "Uncategorized"
		self.complete = false
		self.createdAt = Date()
		self.details = "Details"
		self.name = "Task A"
//		self.id = 0
		self.isNew = false
		self.priority = 0
		self.reminder = Date()
		self.reminderState = false
	}
	
	// reminder date - must include a non-nil date, any date placed before the current time will be ignored for notifications
	func create(context: NSManagedObjectContext, taskName: String, categoryName: String, createdAt: Date, reminderDate: Date, priority: Int, redact: Int) {
		print("change id to UUID?")
		self.name = taskName
		self.complete = false
		self.carryOver = false
		self.category = categoryName
		self.isNew = false
		self.priority = Int16(priority)
		self.createdAt = createdAt // id
		self.reminder = reminderDate
		self.reminderState = false
		self.redactStyle = Int16(redact)
		self.taskToNotes = NSOrderedSet()
		self.taskToPhotos = NSOrderedSet()
		self.updateAt = createdAt //used mainly to force a NSFetchedResultsController trigger
		let reminder = TaskReminder(context: context)
		// default
		reminder.isAllDay = false
		reminder.reminder = nil
		self.taskToReminder = reminder
	}
	
	func ekReminderToTask(reminder: EKReminder) {
		//CoreData Task entity needs to include a EKReminder unique identifier
		self.name = reminder.title // cap title to character limit
		self.complete = reminder.isCompleted
		self.details = reminder.notes // cap description to character limit
		self.createdAt = Calendar.current.today()
		self.priority = convertApplePriorityToShortlist(applePriority: reminder.priority)
		
		self.carryOver = false
		self.isNew = false
		
		self.reminderState = reminder.hasAlarms
		if (reminder.hasAlarms) {
			self.reminder = self.createdAt
		}
		
		self.reminderId = reminder.calendarItemIdentifier
	}
	
	// Apple's Reminder App priority standard - 0 none/9 low 5 medium 1 high
	func convertApplePriorityToShortlist(applePriority: Int) -> Int16 {
		switch applePriority {
			case 0: // low/none
				return Priority.low.rawValue
			case 5:
				return Priority.medium.rawValue
			case 1:
				return Priority.high.rawValue
			case 9:
				return Priority.low.rawValue
			default:
				return Priority.low.rawValue
		}
	}
	
	func convertShortlistPriorityToApple() -> Int {
		
		if let p = Priority.init(rawValue: self.priority) {
			
			switch p {
				case .low, .none:
					return 9
				case .medium:
					return 5
				case .high:
					return 1
			}
		}
		return 0
	}
	
	func redactionStyle() -> RedactStyle {
		if let style = RedactStyle(rawValue: Int(redactStyle)) {
			return style
		}
		// default case
		return .none
	}
	
	func redactedText(with text: String) -> NSAttributedString? {
		let component = RedactComponent(redactStyle: RedactStyle(rawValue: Int(redactStyle)) ?? .none)
		return component.effect.styleText(with: text)
	}
	
	func priorityText() -> String {
		if let p = Priority(rawValue: priority) {
			return p.stringValue
		}
		// default
		return Priority.none.stringValue
	}
	
	func description() {
		
	}
}
