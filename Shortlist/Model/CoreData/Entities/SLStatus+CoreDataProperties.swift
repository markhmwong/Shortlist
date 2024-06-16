//
//  SLStatus+CoreDataProperties.swift
//  Shortlist
//
//  Created by Mark Wong on 16/6/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension SLStatus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SLStatus> {
        return NSFetchRequest<SLStatus>(entityName: "SLStatus")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var statusToTask: NSSet?

}

// MARK: Generated accessors for statusToTask
extension SLStatus {

    @objc(addStatusToTaskObject:)
    @NSManaged public func addToStatusToTask(_ value: SLTask)

    @objc(removeStatusToTaskObject:)
    @NSManaged public func removeFromStatusToTask(_ value: SLTask)

    @objc(addStatusToTask:)
    @NSManaged public func addToStatusToTask(_ values: NSSet)

    @objc(removeStatusToTask:)
    @NSManaged public func removeFromStatusToTask(_ values: NSSet)

}

extension SLStatus : Identifiable {

}
