//
//  Day+CoreDataProperties.swift
//  Five
//
//  Created by Mark Wong on 20/7/19.
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
    @NSManaged public var taskLimit: Int64
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
