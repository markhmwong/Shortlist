//
//  BackLog+CoreDataProperties.swift
//  Shortlist
//
//  Created by Mark Wong on 18/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension BackLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BackLog> {
        return NSFetchRequest<BackLog>(entityName: "BackLog")
    }

    @NSManaged public var name: String?
    @NSManaged public var backLogToBigListTask: NSSet?
	@NSManaged public var backLogToTask: NSSet?
	
}

// MARK: Generated accessors for bigListToBigListTask
extension BackLog {

    @objc(addBackLogToBigListTaskObject:)
    @NSManaged public func addToBackLogToBigListTask(_ value: BigListTask)

    @objc(removeBackLogToBigListTaskObject:)
    @NSManaged public func removeFromBackLogToBigListTask(_ value: BigListTask)

    @objc(addBackLogToBigListTask:)
    @NSManaged public func addToBackLogToBigListTask(_ values: NSSet)

    @objc(removeBackLogToBigListTask:)
    @NSManaged public func removeFromBackLogToBigListTask(_ values: NSSet)

	
	func create(name: String) {
		self.name = name
	}
	
}

// MARK: Generated accessors for backLogToTask
extension BackLog {

    @objc(addBackLogToTaskObject:)
    @NSManaged public func addToBackLogToTask(_ value: Task)

    @objc(removeBackLogToTaskObject:)
    @NSManaged public func removeFromBackLogToTask(_ value: Task)

    @objc(addBackLogToTask:)
    @NSManaged public func addToBackLogToTask(_ values: NSSet)

    @objc(removeBackLogToTask:)
    @NSManaged public func removeFromBackLogToTask(_ values: NSSet)

}
