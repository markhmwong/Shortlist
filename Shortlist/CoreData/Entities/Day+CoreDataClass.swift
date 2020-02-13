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
			stats.highPriority = Int16(highLimit)
		} else {
			stats.highPriority = 0
		}
		
		if let mediumLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.MediumPriorityLimit) {
			stats.mediumPriority = Int16(mediumLimit)
		} else {
			stats.mediumPriority = 0
		}
		
		if let lowLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.LowPriorityLimit) {
			stats.lowPriority = Int16(lowLimit)
		} else {
			stats.lowPriority = 0
		}

		stats.totalCompleted = 0
		stats.totalTasks = 0
		
		
        self.month = Calendar.current.monthToInt() // Stats
        self.year = Calendar.current.yearToInt() // Stats
        self.day = Int16(Calendar.current.todayToInt()) // Stats
    }
	
	func createAssociatedStats() {
		
	}
	
	func createNewDayAsPaddedDay(date: Date = Calendar.current.today()) {
        self.createdAt = date as NSDate
		self.dayToStats?.totalCompleted = 0
		
		self.dayToStats?.highPriority = 1
		self.dayToStats?.mediumPriority = 5
		self.dayToStats?.lowPriority = 5
		
		self.dayToStats?.totalTasks = 0
        self.month = Calendar.current.monthToInt() // Stats
        self.year = Calendar.current.yearToInt() // Stats
        self.day = Int16(Calendar.current.todayToInt()) // Stats
		
	}
}
