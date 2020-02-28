//
//  Day+CoreDataClass.swift
//  Five
//
//  Created by Mark Wong on 20/8/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Day)
public class Day: NSManagedObject {
    
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
		
		self.highPriorityLimit = 2
		self.mediumPriorityLimit = 3
		self.lowPriorityLimit = 3
		self.dayToStats = dayStats
        self.month = Calendar.current.monthToInt() // Stats
        self.year = Calendar.current.yearToInt() // Stats
        self.day = Int16(Calendar.current.todayToInt()) // Stats
	}

	func updateTotalComplete(numTasks: Int64) {
		guard let _stats = self.dayToStats else { return }
		_stats.totalCompleted += numTasks
	}
	
}
