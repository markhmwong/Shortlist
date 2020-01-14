//
//  StatsCategoryComplete+CoreDataProperties.swift
//  Shortlist
//
//  Created by Mark Wong on 17/12/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension StatsCategoryComplete {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StatsCategoryComplete> {
        return NSFetchRequest<StatsCategoryComplete>(entityName: "StatsCategoryComplete")
    }

    @NSManaged public var name: String?
    @NSManaged public var completeCount: Int16
    @NSManaged public var completeToStats: Stats?

}
