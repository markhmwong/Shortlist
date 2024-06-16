//
//  SLTask+CoreDataProperties.swift
//  Shortlist
//
//  Created by Mark Wong on 16/6/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension SLTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SLTask> {
        return NSFetchRequest<SLTask>(entityName: "SLTask")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var media: String?
    @NSManaged public var name: String?
    @NSManaged public var priority: Int16
    @NSManaged public var reminder: Date?
    @NSManaged public var taskDescription: String?
    @NSManaged public var taskToStatus: SLStatus?
    @NSManaged public var taskToCategory: SLCategory?

}

extension SLTask : Identifiable {

}
