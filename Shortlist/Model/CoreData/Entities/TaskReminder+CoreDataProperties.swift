//
//  TaskReminder+CoreDataProperties.swift
//  
//
//  Created by Mark Wong on 12/10/20.
//
//

import Foundation
import CoreData


extension TaskReminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskReminder> {
        return NSFetchRequest<TaskReminder>(entityName: "TaskReminder")
    }

    @NSManaged public var isAllDay: Bool
    @NSManaged public var reminder: Date?
    @NSManaged public var reminderId: String?
    @NSManaged public var isCustom: Bool
    @NSManaged public var isPreset: Bool
    @NSManaged public var presetType: Int16
    @NSManaged public var reminderToTask: Task?
}
