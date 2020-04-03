//
//  Task+CoreDataProperties.swift
//  Five
//
//  Created by Mark Wong on 21/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData
import EventKit

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var complete: Bool
    @NSManaged public var name: String?
	@NSManaged public var details: String?
    @NSManaged public var taskToDay: Day?
    @NSManaged public var carryOver: Bool
    @NSManaged public var isNew: Bool
	@NSManaged public var createdAt: NSDate?
	@NSManaged public var reminder: NSDate?
    @NSManaged public var reminderState: Bool
	// a unique string provided by the Apple Reminder app. Used to match existing tasks
	@NSManaged public var reminderId: String?
    // The priority level beginning from 0 as the highest
    @NSManaged public var priority: Int16
    
    // The category the task belongs to. List of categories below as enums
    @NSManaged public var category: String
	
	/*
	
		Unit Test Functions
	
	*/
	
	// currently used in unit tests
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
		let count = self.category.count
		
		if (count >= TaskCharacterLimits.taskCategoryMinimumCharacterLimit && count <= TaskCharacterLimits.taskCategoryMaximumCharacterLimit) {
			return true
		} else if (count < TaskCharacterLimits.taskCategoryMinimumCharacterLimit || count > TaskCharacterLimits.taskCategoryMaximumCharacterLimit) {
			return false
		}
		
		return false
	}
	
	func fillTaskWithSampleData() {
		self.carryOver = false
		self.category = "Uncategorized"
		self.complete = false
		self.createdAt = Date() as NSDate
		self.details = "Details"
		self.name = "Task A"
//		self.id = 0
		self.isNew = false
		self.priority = 0
		self.reminder = Date() as NSDate
		self.reminderState = false
	}
	
	// reminder date - must include a non-nil date, any date placed before the current time will be ignored for notifications
	func create(context: NSManagedObjectContext, taskName: String, categoryName: String, createdAt: Date, reminderDate: Date, priority: Int) {
		self.name = taskName
		self.complete = false
		self.carryOver = false
		self.category = categoryName
		self.isNew = false
		self.priority = Int16(priority)
		self.createdAt = createdAt as NSDate
		self.reminder = reminderDate as NSDate
		self.reminderState = false
	}
	
	func ekReminderToTask(reminder: EKReminder) {
		//CoreData Task entity needs to include a EKReminder unique identifier
		self.name = reminder.title // cap title to character limit
		self.complete = reminder.isCompleted
		self.details = reminder.notes // cap description to character limit
		self.createdAt = Calendar.current.today() as NSDate
		self.priority = convertApplePriorityToShortlist(applePriority: reminder.priority)
		
		self.carryOver = false
		self.isNew = false
		
		self.reminderState = reminder.hasAlarms
		if (reminder.hasAlarms) {
			self.reminder = self.createdAt
		}
		
		self.reminderId = reminder.calendarItemIdentifier
	}
	
	// Apple's Priority standard - 0 none/9 low 5 medium 1 high
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
	
	
//	func setReminder(reminder: EKReminder) {
		
//		if (reminder.hasAlarms) {
//			self.reminder = reminder.alarms?[0].absoluteDate
//			self.reminderState = reminder.hasAlarms
//		}
		
//	}
	

}
