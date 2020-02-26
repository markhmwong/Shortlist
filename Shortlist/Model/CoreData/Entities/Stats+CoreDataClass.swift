//
//  Stats+CoreDataClass.swift
//  Shortlist
//
//  Created by Mark Wong on 17/12/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Stats)
public class Stats: NSManagedObject {
	func addToTotalTasks(numTasks: Int64) {
		self.totalTasks = self.totalTasks + numTasks
	}

	func removeFromTotalTasks(numTasks: Int64) {
		if (self.totalTasks > 0) {
			self.totalTasks = self.totalTasks - numTasks
		}
	}

	func addToTotalCompleteTasks(numTasks: Int64) {
		self.totalCompleteTasks = self.totalCompleteTasks + numTasks
	}

	func removeFromTotalCompleteTasks(numTasks: Int64) {
		if (self.totalCompleteTasks > 0) {
			self.totalCompleteTasks = self.totalCompleteTasks - numTasks
		}
	}

	func addToTotalIncompleteTasks(numTasks: Int64) {
		self.totalIncompleteTasks = self.totalIncompleteTasks + numTasks
	}

	func removeFromTotalIncompleteTasks(numTasks: Int64) {
		if (self.totalIncompleteTasks > 0) {
			self.totalIncompleteTasks = self.totalIncompleteTasks - numTasks
		}
	}
	
	func removeFromPriority(numTasks: Int64, priority: Priority) {
		switch priority {
			case .high:
				if (self.totalHighPriorityTasks > 0) {
					self.totalHighPriorityTasks = self.totalHighPriorityTasks - numTasks
				}
			case .medium:
				if (self.totalMediumPriorityTasks > 0) {
					self.totalMediumPriorityTasks = self.totalMediumPriorityTasks - numTasks
				}
			case .low:
				if (self.totalLowPriorityTasks > 0) {
					self.totalLowPriorityTasks = self.totalLowPriorityTasks - numTasks
				}
			case .none:
				()
		}
	}
	
	func addToPriority(numTasks: Int64, priority: Priority) {
		switch priority {
			case .high:
				self.totalHighPriorityTasks = self.totalHighPriorityTasks + numTasks
			case .medium:
				self.totalMediumPriorityTasks = self.totalMediumPriorityTasks + numTasks
			case .low:
				self.totalLowPriorityTasks = self.totalLowPriorityTasks + numTasks
			case .none:
				()
		}
	}
	
	func addToCategoryACompleteTask(category: String) {
		let predicate = NSPredicate(format: "name == %@", category)
		let setComplete = statsToComplete?.filtered(using: predicate) as! Set<StatsCategoryComplete>
		if let category = setComplete.first {
			category.completeCount = category.completeCount + 1
		}
	}
	
	func removeFromCategoryACompleteTask(category: String) {
		let predicate = NSPredicate(format: "name == %@", category)
		let setComplete = statsToComplete?.filtered(using: predicate) as! Set<StatsCategoryComplete>
		if let category = setComplete.first {
			category.completeCount = category.completeCount + 1
		}
	}
}
