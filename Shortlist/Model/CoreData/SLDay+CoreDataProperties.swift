//
//  SLDay+CoreDataProperties.swift
//  
//
//  Created by Mark Wong on 13/4/2024.
//
//

import Foundation
import CoreData


extension SLDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SLDay> {
        return NSFetchRequest<SLDay>(entityName: "SLDay")
    }

    @NSManaged public var date: Date?
    @NSManaged public var taskLimit: Int64
    @NSManaged public var dayToTask: NSSet?

}

// MARK: Generated accessors for dayToTask
extension SLDay {

    @objc(addDayToTaskObject:)
    @NSManaged public func addToDayToTask(_ value: SLTask)

    @objc(removeDayToTaskObject:)
    @NSManaged public func removeFromDayToTask(_ value: SLTask)

    @objc(addDayToTask:)
    @NSManaged public func addToDayToTask(_ values: NSSet)

    @objc(removeDayToTask:)
    @NSManaged public func removeFromDayToTask(_ values: NSSet)

}
