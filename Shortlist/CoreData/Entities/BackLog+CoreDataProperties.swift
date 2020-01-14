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
