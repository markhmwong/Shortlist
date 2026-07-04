//
//  SLDay+CoreDataProperties.swift
//  Shortlist
//
//  Created by Mark Wong on 4/7/2026.
//  Copyright © 2026 Mark Wong. All rights reserved.
//

import Foundation
import CoreData

extension SLDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SLDay> {
        return NSFetchRequest<SLDay>(entityName: "SLDay")
    }

    @NSManaged public var date: Date
    @NSManaged public var goalCount: Int16
    @NSManaged public var completedCount: Int16
    @NSManaged public var isCleanSweep: Bool
}

extension SLDay: Identifiable { }
