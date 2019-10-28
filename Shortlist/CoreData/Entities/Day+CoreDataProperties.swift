//
//  Day+CoreDataProperties.swift
//  Five
//
//  Created by Mark Wong on 20/8/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var createdAt: NSDate?
    // Total Task limit for the day
    @NSManaged public var taskLimit: Int16
    @NSManaged public var year: Int16
    @NSManaged public var month: Int16
    
    // Represents the date of the month not the day of the week
    @NSManaged public var day: Int16
    
    // Total tasks the user has completed
    @NSManaged public var totalCompleted: Int16
    
    // Total tasks whether they are complete or incomplete
    @NSManaged public var totalTasks: Int16
    
    @NSManaged public var dayToTask: NSSet?

}

// MARK: Generated accessors for dayToTask
extension Day {

    @objc(addDayToTaskObject:)
    @NSManaged public func addToDayToTask(_ value: Task)

    @objc(removeDayToTaskObject:)
    @NSManaged public func removeFromDayToTask(_ value: Task)

    @objc(addDayToTask:)
    @NSManaged public func addToDayToTask(_ values: NSSet)

    @objc(removeDayToTask:)
    @NSManaged public func removeFromDayToTask(_ values: NSSet)

}