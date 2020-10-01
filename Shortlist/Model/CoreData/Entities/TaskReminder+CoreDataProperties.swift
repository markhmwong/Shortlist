//
//  TaskReminder+CoreDataProperties.swift
//  
//
//  Created by Mark Wong on 30/9/20.
//
//

import Foundation
import CoreData


extension TaskReminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskReminder> {
        return NSFetchRequest<TaskReminder>(entityName: "TaskReminder")
    }

    @NSManaged public var reminder: Date?
    @NSManaged public var isAllDay: Bool
    @NSManaged public var reminderToTask: Task?

}
