//
//  DayStats+CoreDataProperties.swift
//  
//
//  Created by Mark Wong on 7/2/20.
//
//

import Foundation
import CoreData


extension DayStats {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayStats> {
        return NSFetchRequest<DayStats>(entityName: "DayStats")
    }

    @NSManaged public var accolade: String?
    @NSManaged public var highPriority: Int64
    @NSManaged public var lowPriority: Int64
    @NSManaged public var mediumPriority: Int64
    @NSManaged public var totalCompleted: Int64
    @NSManaged public var totalTasks: Int64
    @NSManaged public var statsToDay: Day?

}
