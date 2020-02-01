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
		
        if let highLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.HighPriorityLimit) {
			self.highPriorityLimit = Int16(highLimit)
		} else {
			self.highPriorityLimit = 0
		}
		
        if let mediumLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.MediumPriorityLimit) {
			self.mediumPriorityLimit = Int16(mediumLimit)
		} else {
			self.mediumPriorityLimit = 0
		}
		
        if let lowLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.LowPriorityLimit) {
			self.lowPriorityLimit = Int16(lowLimit)
		} else {
			self.lowPriorityLimit = 0
		}
		
		self.totalCompleted = 0
        self.totalTasks = 0
        self.month = Calendar.current.monthToInt() // Stats
        self.year = Calendar.current.yearToInt() // Stats
        self.day = Int16(Calendar.current.todayToInt()) // Stats
    }
	
	func createNewDayAsPaddedDay(date: Date = Calendar.current.today()) {
        self.createdAt = date as NSDate
		self.totalCompleted = 0
		
		self.highPriorityLimit = 1
		self.mediumPriorityLimit = 5
		self.lowPriorityLimit = 5
		
        self.totalTasks = 0
        self.month = Calendar.current.monthToInt() // Stats
        self.year = Calendar.current.yearToInt() // Stats
        self.day = Int16(Calendar.current.todayToInt()) // Stats
		
	}
	

	
}
