//
//  BigListTask+CoreDataProperties.swift
//  Shortlist
//
//  Created by Mark Wong on 17/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension BigListTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BigListTask> {
        return NSFetchRequest<BigListTask>(entityName: "BigListTask")
    }

    @NSManaged public var carryOver: Bool
    @NSManaged public var category: String?
    @NSManaged public var complete: Bool
    @NSManaged public var details: String?
    @NSManaged public var id: Int16
    @NSManaged public var isNew: Bool
    @NSManaged public var name: String?
    @NSManaged public var priority: Int16
    @NSManaged public var bigListTaskToBigList: BigListCategories?

}
