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
		dayStats.highPriority = 1
		dayStats.lowPriority = 3
		dayStats.mediumPriority = 3
		dayStats.accolade = ""
		
		self.dayToStats = dayStats
		
		guard let stats = self.dayToStats else { return }
		
		if let highLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.HighPriorityLimit) {
			stats.highPriority = Int16(highLimit)
		} else {
			KeychainWrapper.standard.set(1, forKey: SettingsKeyChainKeys.HighPriorityLimit)
			stats.highPriority = 1
		}
		
		if let mediumLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.MediumPriorityLimit) {
			stats.mediumPriority = Int16(mediumLimit)
		} else {
			KeychainWrapper.standard.set(3, forKey: SettingsKeyChainKeys.MediumPriorityLimit)
			stats.mediumPriority = 3
		}
		
		if let lowLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.LowPriorityLimit) {
			stats.lowPriority = Int16(lowLimit)
		} else {
			KeychainWrapper.standard.set(3, forKey: SettingsKeyChainKeys.LowPriorityLimit)
			stats.lowPriority = 3
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
		
		dayStats.highPriority = 1
		dayStats.mediumPriority = 3
		dayStats.lowPriority = 3
		
		self.dayToStats?.totalTasks = 0
		
		self.dayToStats = dayStats
        self.month = Calendar.current.monthToInt() // Stats
        self.year = Calendar.current.yearToInt() // Stats
        self.day = Int16(Calendar.current.todayToInt()) // Stats
		
	}
}
