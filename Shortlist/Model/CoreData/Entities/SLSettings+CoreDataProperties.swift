//
//  SLSettings+CoreDataProperties.swift
//  Shortlist
//
//  Created by Mark Wong on 27/7/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension SLSettings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SLSettings> {
        return NSFetchRequest<SLSettings>(entityName: "SLSettings")
    }

    @NSManaged public var taskLimit: Int16

}

extension SLSettings : Identifiable {

}
