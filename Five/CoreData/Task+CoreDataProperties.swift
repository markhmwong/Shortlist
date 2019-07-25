//
//  Task+CoreDataProperties.swift
//  Five
//
//  Created by Mark Wong on 21/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var complete: Bool
    @NSManaged public var name: String?
    @NSManaged public var id: Int16
    @NSManaged public var taskToDay: Day?
    @NSManaged public var carryOver: Bool
}
