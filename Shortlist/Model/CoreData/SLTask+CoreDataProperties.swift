//
//  SLTask+CoreDataProperties.swift
//  
//
//  Created by Mark Wong on 9/6/2024.
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
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var media: String?
    @NSManaged public var name: String?
    @NSManaged public var priority: Int16
    @NSManaged public var category: String?
    @NSManaged public var long: Double
    @NSManaged public var lat: Double
    @NSManaged public var reminder: Date?
    @NSManaged public var taskToDay: SLDay?

}

extension SLTask {
    
}
