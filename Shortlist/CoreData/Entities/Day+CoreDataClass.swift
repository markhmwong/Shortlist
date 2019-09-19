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
    func createNewDay() {
        self.createdAt = Calendar.current.today() as NSDate
        if let limit = KeychainWrapper.standard.integer(forKey: KeyChainKeys.TaskLimit) {
            self.taskLimit = Int16(limit)
        } else {
            self.taskLimit = 3
        }
        self.totalTasks = self.taskLimit
        self.month = Calendar.current.monthToInt() // Stats
        self.year = Calendar.current.yearToInt() // Stats
        self.day = Int16(Calendar.current.todayToInt()) // Stats
    }
    
}
