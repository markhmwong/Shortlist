//
//  TaskPhotos+CoreDataProperties.swift
//  
//
//  Created by Mark Wong on 22/9/20.
//
//

import Foundation
import CoreData


extension TaskPhotos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskPhotos> {
        return NSFetchRequest<TaskPhotos>(entityName: "TaskPhotos")
    }

    @NSManaged public var photo: Data?
    @NSManaged public var thumbnail: Data?
    @NSManaged public var id: UUID?
    @NSManaged public var photosToTask: Task?
	@NSManaged public var caption: String?

}
