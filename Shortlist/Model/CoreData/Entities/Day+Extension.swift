//
//  Day+Extension.swift
//  Shortlist
//
//  Created by Mark Wong on 21/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

extension Day {
	// creates a new day based on today's date
	func createNewDay(date: Date = Calendar.current.today()) {
		self.createdAt = date as NSDate
		
		guard let managedObjectContext = self.managedObjectContext else { return }
		
		let dayStats = DayStats(context: managedObjectContext)
		dayStats.totalCompleted = 0
		dayStats.totalTasks = 0
		dayStats.highPriority = 0
		dayStats.lowPriority = 0
		dayStats.mediumPriority = 0
		dayStats.accolade = ""
		
		self.dayToStats = dayStats
		
		guard let stats = self.dayToStats else { return }
		
		if let highLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.HighPriorityLimit) {
			self.highPriorityLimit = Int16(highLimit)
		} else {
			KeychainWrapper.standard.set(1, forKey: SettingsKeyChainKeys.HighPriorityLimit)
			self.highPriorityLimit = 1
		}
		
		if let mediumLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.MediumPriorityLimit) {
			self.mediumPriorityLimit = Int16(mediumLimit)
		} else {
			KeychainWrapper.standard.set(3, forKey: SettingsKeyChainKeys.MediumPriorityLimit)
			self.mediumPriorityLimit = 3
		}
		
		if let lowLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.LowPriorityLimit) {
			self.lowPriorityLimit = Int16(lowLimit)
		} else {
			KeychainWrapper.standard.set(3, forKey: SettingsKeyChainKeys.LowPriorityLimit)
			self.lowPriorityLimit = 3
		}

		stats.totalCompleted = 0
		stats.totalTasks = 0
		
		self.month = Calendar.current.monthToInt() // Stats
		self.year = Calendar.current.yearToInt() // Stats
		self.day = Int16(Calendar.current.todayToInt()) // Stats
		
		// Set up relationship
		self.dayToTask = Set<Task>() as NSSet
	}

	func createNewDayAsPaddedDay(date: Date = Calendar.current.today()) {
		self.createdAt = date as NSDate
		
		guard let managedObjectContext = self.managedObjectContext else { return }
		let dayStats = DayStats(context: managedObjectContext)

		dayStats.totalCompleted = 0
		
		dayStats.highPriority = 0
		dayStats.mediumPriority = 0
		dayStats.lowPriority = 0
		dayStats.totalTasks = 0
		
		self.highPriorityLimit = 1
		self.mediumPriorityLimit = 3
		self.lowPriorityLimit = 3
		self.dayToStats = dayStats
		self.month = Calendar.current.monthToInt() // Stats
		self.year = Calendar.current.yearToInt() // Stats
		self.day = Int16(Calendar.current.todayToInt()) // Stats
	}
	
	// Used to create fake statistics mainly for screenshots to show off the stats page
	func createMockDay(date: Date = Calendar.current.today()) {
		self.createdAt = date as NSDate
		
		guard let managedObjectContext = self.managedObjectContext else { return }
		let dayStats = DayStats(context: managedObjectContext)
		dayStats.totalTasks = Int64.random(in: 2...8)
		dayStats.totalCompleted = Int64.random(in: 2...dayStats.totalTasks)
		
		dayStats.highPriority = Int64.random(in: 1...2)
		dayStats.mediumPriority = Int64.random(in: 1...3)
		dayStats.lowPriority = Int64.random(in: 1...3)
		self.dayToStats = dayStats
		self.highPriorityLimit = 2
		self.mediumPriorityLimit = 3
		self.lowPriorityLimit = 3
		self.month = Calendar.current.monthToInt() // Stats
		self.year = Calendar.current.yearToInt() // Stats
		self.day = Int16(Calendar.current.todayToInt()) // Stats
	}

	func updateTotalComplete(numTasks: Int64) {
		guard let _stats = self.dayToStats else { return }
		_stats.totalCompleted += numTasks
	}
	
	func sortTasks() -> [Task]? {
		if let set = self.dayToTask as? Set<Task> {
			if (!set.isEmpty) {
				return set.sorted(by: { (taskA, taskB) -> Bool in
					// sort same priority by date
					if (taskA.priority == taskB.priority) {
						return ((taskA.createdAt! as Date).compare(taskB.createdAt! as Date) == .orderedAscending)
					} else {
						// otherwise order by priority
						return taskA.priority < taskB.priority
					}
				})
			} else {
				return nil
			}
		}
		return nil
	}
	
	func addTask(with task: Task) {
		
		// set up the relationship between Day and Task
		if (self.dayToTask == nil) {
			self.dayToTask = Set<Task>() as NSSet
		}
		
		self.addToDayToTask(task)
		
	}
}
