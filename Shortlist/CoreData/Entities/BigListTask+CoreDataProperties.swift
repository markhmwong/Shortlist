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
    @NSManaged public var bigListTaskToBigList: BackLog?
	@NSManaged public var reminder: NSDate?
    @NSManaged public var reminderState: Bool
	@NSManaged public var createdAt: NSDate?
	
	func create(context: NSManagedObjectContext, idNum: Int, taskName: String, categoryName: String, createdAt: Date, reminderDate: Date) {
		self.name = taskName
		self.complete = false
		self.carryOver = false
		self.category = categoryName
		self.isNew = false
		self.priority = Int16(idNum)
		self.id = Int16(idNum)
		self.createdAt = createdAt as NSDate
		self.reminder = reminderDate as NSDate
	}
	
}
