//
//  BigListCategories+CoreDataProperties.swift
//  Shortlist
//
//  Created by Mark Wong on 18/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension BigListCategories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BigListCategories> {
        return NSFetchRequest<BigListCategories>(entityName: "BigListCategories")
    }

    @NSManaged public var name: String?
    @NSManaged public var bigListToBigListTask: NSSet?

}

// MARK: Generated accessors for bigListToBigListTask
extension BigListCategories {

    @objc(addBigListToBigListTaskObject:)
    @NSManaged public func addToBigListToBigListTask(_ value: BigListTask)

    @objc(removeBigListToBigListTaskObject:)
    @NSManaged public func removeFromBigListToBigListTask(_ value: BigListTask)

    @objc(addBigListToBigListTask:)
    @NSManaged public func addToBigListToBigListTask(_ values: NSSet)

    @objc(removeBigListToBigListTask:)
    @NSManaged public func removeFromBigListToBigListTask(_ values: NSSet)

}
