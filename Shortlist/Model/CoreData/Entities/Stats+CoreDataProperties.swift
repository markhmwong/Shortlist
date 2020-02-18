//
//  Stats+CoreDataProperties.swift
//  Shortlist
//
//  Created by Mark Wong on 17/12/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension Stats {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stats> {
        return NSFetchRequest<Stats>(entityName: "Stats")
    }

    @NSManaged public var favoriteTimeToComplete: Date?
    @NSManaged public var id: Int16
    @NSManaged public var totalCompleteTasks: Int64
    @NSManaged public var totalIncompleteTasks: Int64
    @NSManaged public var totalTasks: Int64
    @NSManaged public var statsToComplete: NSSet?
    @NSManaged public var statsToIncomplete: NSSet?
	@NSManaged public var totalHighPriorityTasks: Int64
	@NSManaged public var totalMediumPriorityTasks: Int64
	@NSManaged public var totalLowPriorityTasks: Int64
}

// MARK: Generated accessors for statsToComplete
extension Stats {

    @objc(addStatsToCompleteObject:)
    @NSManaged public func addToStatsToComplete(_ value: StatsCategoryComplete)

    @objc(removeStatsToCompleteObject:)
    @NSManaged public func removeFromStatsToComplete(_ value: StatsCategoryComplete)

    @objc(addStatsToComplete:)
    @NSManaged public func addToStatsToComplete(_ values: NSSet)

    @objc(removeStatsToComplete:)
    @NSManaged public func removeFromStatsToComplete(_ values: NSSet)

}

// MARK: Generated accessors for statsToIncomplete
extension Stats {

    @objc(addStatsToIncompleteObject:)
    @NSManaged public func addToStatsToIncomplete(_ value: StatsCategoryIncomplete)

    @objc(removeStatsToIncompleteObject:)
    @NSManaged public func removeFromStatsToIncomplete(_ value: StatsCategoryIncomplete)

    @objc(addStatsToIncomplete:)
    @NSManaged public func addToStatsToIncomplete(_ values: NSSet)

    @objc(removeStatsToIncomplete:)
    @NSManaged public func removeFromStatsToIncomplete(_ values: NSSet)

}
