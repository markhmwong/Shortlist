//
//  TaskTest.swift
//  ShortlistTests
//
//  Created by Mark Wong on 11/11/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import XCTest
@testable import Shortlist

/*

	Test Functions to examine individual properties of the Core Data Entity Task.
	Here we ensure that the properties abide by the restriction set in place by the global parameters under the struct Task TaskCharacterLimits. Although a different validation is placed in the textfield delegates. These simply check the length

*/

class TaskTest: XCTestCase {

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
	
	func sampleTask(_ category: String = "Uncategorized", _ details: String = "A short detailed description of the task", _ name: String = "A short name of the task") -> Task {
		let task: Task = Task(context: persistentContainer.viewContext)
		task.carryOver = false
		task.category = category
		task.complete = false
		task.createdAt = Date() as NSDate
		task.details = details
		task.name = name
		task.id = 0
		task.isNew = false
		task.priority = 0
		task.reminder = Date() as NSDate
		task.reminderState = false
		return task
	}
	
	// Create a simple task that abides by the data types of the core data entity
	// If you're looking for a test case that checks if the object exists in the persistent store and is a part of the Day object, please look at the DayTest.swift
	func testCreateTask() {
		let task: Task = sampleTask()
        XCTAssertNotNil(task)
	}
	
	func testTasksMaximumNameLengthDoesExceedLimit() {
		let task: Task = sampleTask("","","Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limitTesting the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limitTesting the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit")
		XCTAssertFalse(task.nameLengthRestriction())
	}
	
	func testTasksMaximumNameLengthDoesNotExceedLimit() {
		let task: Task = sampleTask("","","Task name does falls within character limits")
		XCTAssertTrue(task.nameLengthRestriction())
	}
	
	// task name under the minimum limit
	func testTasksMinimumNameLengthDoesNotExceedLimit() {
		let task: Task = sampleTask("","","")
		XCTAssertFalse(task.nameLengthRestriction())
	}
	
	// task name under the minimum limit
	func testTasksMinimumDetailsLengthDoesExceedLimit() {
		let task: Task = sampleTask("","","")
		XCTAssertFalse(task.detailsLengthRestriction())
	}
	
	// Character limit is 480
	func testTaskDetailsMaximumLengthDoesExceedLimit() {
		let task: Task = sampleTask("","Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limitTesting the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limitTesting the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limitTesting the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limitTesting the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limitTesting the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limitTesting the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limitTesting the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limitTesting the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limitTesting the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limitTesting the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limitTesting the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limitTesting the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limitTesting the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit, Testing the 240 character limit","")
		XCTAssertFalse(task.detailsLengthRestriction())
	}
	
	func testTaskDetailsLengthDoesNotExceedLimits() {
		let task: Task = sampleTask("","Valid","")
		XCTAssertTrue(task.detailsLengthRestriction())
	}
	
	func testTaskCategoryMinimumLimit() {
		let task: Task = sampleTask("Valid","","")
		XCTAssertTrue(task.categoryLengthRestriction())
	}
	
	func testTaskCategoryMaximumLimit() {
		let task: Task = sampleTask("ValidCategoryNameOverTheCharacterLimit","","")
		XCTAssertFalse(task.categoryLengthRestriction())
	}
	
	func testTaskPriorityValid() {
		let task: Task = Task(context: persistentContainer.viewContext)
		task.priority = 1
		XCTAssertTrue(task.priority > 0 && task.priority <= 20) //max 20 tasks
	}
	
	func testTaskPriorityAnInvalidNegativeValue() {
		let task: Task = Task(context: persistentContainer.viewContext)
		task.priority = -1
		XCTAssertFalse(task.priority > 0)
	}
	
	func testTaskIdAValidPositiveValue() {
		let task: Task = Task(context: persistentContainer.viewContext)
		task.id = 20
		XCTAssertFalse(task.priority > 0)
	}
	
	func testTaskIdAInvalidNegativeValue() {
		let task: Task = Task(context: persistentContainer.viewContext)
		task.id = -1
		XCTAssertFalse(task.priority > 0)
	}
	
	func testReminderDateIsAlwaysInFuture() {
		let task: Task = Task(context: persistentContainer.viewContext)
		task.reminder = Date().addingTimeInterval(50.0) as NSDate
		
		guard let reminder = task.reminder else { return }
		
		let delta = reminder.timeIntervalSince(Date())
		wait(for: 2.0)
		XCTAssertTrue(delta > 0.0, "\(delta) Reminder is not set far enough into the future, expectation is to have this reminder not to have run it's course")
	}
	
	func testReminderDateHasPassed() {
		let task: Task = Task(context: persistentContainer.viewContext)
		task.reminder = Date().addingTimeInterval(-50.0) as NSDate
		
		guard let reminder = task.reminder else { return }
		
		let delta = reminder.timeIntervalSince(Date())
		wait(for: 2.0)
		XCTAssertTrue(delta < 0.0, "Reminder is not set far enough into the past, we expect this reminder to have passed and run it's course")
	}
}


extension XCTestCase {

  func wait(for duration: TimeInterval) {
    let waitExpectation = expectation(description: "Waiting")

    let when = DispatchTime.now() + duration
    DispatchQueue.main.asyncAfter(deadline: when) {
      waitExpectation.fulfill()
    }

    // We use a buffer here to avoid flakiness with Timer on CI
    waitForExpectations(timeout: duration + 0.5)
  }
}
