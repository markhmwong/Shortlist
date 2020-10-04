//
//  TaskNotes+CoreDataProperties.swift
//  
//
//  Created by Mark Wong on 22/9/20.
//
//

import Foundation
import CoreData


extension TaskNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskNote> {
        return NSFetchRequest<TaskNote>(entityName: "TaskNote")
    }

    @NSManaged public var note: String?
    @NSManaged public var isButton: Bool
    @NSManaged public var taskNotesToTask: Task?

}
