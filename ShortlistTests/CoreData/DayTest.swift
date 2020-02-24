//
//  DayTest.swift
//  ShortlistTests
//
//  Created by Mark Wong on 11/11/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import XCTest
@testable import Shortlist

/*

	Day Entity test functions

*/

class DayTest: XCTestCase {

	lazy var persistentContainer: PersistentContainer = {
        let container = PersistentContainer(name: "ShortlistModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
	
	
    override func setUp() {
		super.setUp()
    }

    override func tearDown() {
		
    }

	// Validates whether the day object has been successfully created and placed into the persistent store
	func testDayExists() {
		let day: Day = Day(context: persistentContainer.viewContext)
		day.createNewDay()
		persistentContainer.saveContext()
		
		let dayObj: Day? = persistentContainer.fetchDayManagedObject(forDate: Calendar.current.today())
		
		XCTAssertNotNil(dayObj)
	}
	
	// Validates the relationship between the Day and Task objects. A Task should be added to a specific day and be recovered from that day proving that the Task exists within the Day object.
	func testDaysTasks() {
		let day: Day = Day(context: persistentContainer.viewContext)
		day.createNewDay()
		
		persistentContainer.saveContext()
		
		let dayObj: Day? = persistentContainer.fetchDayManagedObject(forDate: Calendar.current.today())

		let taskA: Task = Task(context: persistentContainer.viewContext)
		taskA.fillTaskWithSampleData()
		dayObj?.addToDayToTask(taskA)
		guard let _dayObj = dayObj else { return }
		let tasks = _dayObj.dayToTask as! Set<Task>
		
		let taskObj = Array(tasks)[0]
		let valid: Bool = (taskObj.name == "Task A") && (tasks.count > 0)
		XCTAssertTrue(valid)
		let _ = persistentContainer.deleteAllRecordsIn(entity: Day.self)
	}
	
	func createTask() -> Task {
		let task: Task = Task(context: persistentContainer.viewContext)
		task.carryOver = false
		task.category = "Uncategorized"
		task.complete = false
		task.createdAt = Date() as NSDate
		task.details = "Details"
		task.name = "Task A"
		task.isNew = false
		task.priority = 0
		task.reminder = Date() as NSDate
		task.reminderState = false
		return task
	}
	
	// test deletion
	
}
