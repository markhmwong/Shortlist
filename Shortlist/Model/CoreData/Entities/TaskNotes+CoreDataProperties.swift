//
//  TaskNotes+CoreDataProperties.swift
//  
//
//  Created by Mark Wong on 22/9/20.
//
//

import Foundation
import CoreData


extension TaskNotes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskNotes> {
        return NSFetchRequest<TaskNotes>(entityName: "TaskNotes")
    }

    @NSManaged public var note: String?
    @NSManaged public var isButton: Bool
    @NSManaged public var taskNotesToTask: Task?

}
