//
//  StatsCategoryIncomplete+CoreDataProperties.swift
//  Shortlist
//
//  Created by Mark Wong on 17/12/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension StatsCategoryIncomplete {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StatsCategoryIncomplete> {
        return NSFetchRequest<StatsCategoryIncomplete>(entityName: "StatsCategoryIncomplete")
    }

    @NSManaged public var name: String?
    @NSManaged public var incompleteCount: Int16
    @NSManaged public var incompleteToStats: Stats?

}
