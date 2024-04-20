//
//  SLTask+CoreDataProperties.swift
//  
//
//  Created by Mark Wong on 13/4/2024.
//
//

import Foundation
import CoreData


extension SLTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SLTask> {
        return NSFetchRequest<SLTask>(entityName: "SLTask")
    }

    @NSManaged public var carryOver: Bool
    @NSManaged public var complete: Bool
    @NSManaged public var id: UUID
    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var taskToDay: SLDay?

}
