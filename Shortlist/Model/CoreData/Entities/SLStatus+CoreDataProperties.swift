//
//  SLStatus+CoreDataProperties.swift
//  Shortlist
//
//  Created by Mark Wong on 29/6/2024.
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
    @NSManaged public var statusToTask: SLTask?

}
