//
//  SLCategory+CoreDataProperties.swift
//  Shortlist
//
//  Created by Mark Wong on 16/6/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension SLCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SLCategory> {
        return NSFetchRequest<SLCategory>(entityName: "SLCategory")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var categoryToTask: SLTask?

}

extension SLCategory : Identifiable {

}
