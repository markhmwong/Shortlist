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

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var complete: Bool
    @NSManaged public var name: String?
	@NSManaged public var details: String?
    @NSManaged public var id: Int16
    @NSManaged public var taskToDay: Day?
    @NSManaged public var carryOver: Bool
    @NSManaged public var isNew: Bool
	@NSManaged public var createdAt: NSDate?
	@NSManaged public var reminder: NSDate?
    @NSManaged public var reminderState: Bool

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
		self.id = 0
		self.isNew = false
		self.priority = 0
		self.reminder = Date() as NSDate
		self.reminderState = false
	}
	
	// remove context argument
	func create(context: NSManagedObjectContext, idNum: Int, taskName: String, categoryName: String, createdAt: Date, reminderDate: Date, priority: Int) {
		self.name = taskName
		self.complete = false
		self.carryOver = false
		self.category = categoryName
		self.isNew = false
		self.priority = Int16(priority)
		self.id = Int16(idNum)
		self.createdAt = createdAt as NSDate
		self.reminder = reminderDate as NSDate
	}
}
