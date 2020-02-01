//
//  AwardTests.swift
//  ShortlistTests
//
//  Created by Mark Wong on 28/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import XCTest
@testable import Shortlist

class AwardTests: XCTestCase {

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
	
	func createMockDayObject() -> Day {
		let date = Calendar.current.today()
		let day = Day(context: persistentContainer.viewContext)
		day.createdAt = date as NSDate
		
        if let highLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.HighPriorityLimit) {
			day.highPriorityLimit = Int16(highLimit)
		} else {
			day.highPriorityLimit = 0
		}
		
        if let mediumLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.MediumPriorityLimit) {
			day.mediumPriorityLimit = Int16(mediumLimit)
		} else {
			day.mediumPriorityLimit = 0
		}
		
        if let lowLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.LowPriorityLimit) {
			day.lowPriorityLimit = Int16(lowLimit)
		} else {
			day.lowPriorityLimit = 0
		}
		day.totalCompleted = 0
        day.totalTasks = 0
        day.month = Calendar.current.monthToInt() // Stats
        day.year = Calendar.current.yearToInt() // Stats
        day.day = Int16(Calendar.current.todayToInt()) // Stats
		
		return day
	}
	
	func createMockTasks(day: Day, complete: Bool, priority: Int) -> Task {
		let task = Task.init(context: persistentContainer.viewContext)
		task.create(context: persistentContainer.viewContext, idNum: 0, taskName: "Test High Priority Task", categoryName: "Uncategorized", createdAt: Date(), reminderDate: Date(), priority: priority)
		task.complete = complete
		return task
	}
	
	func createMockTasks(day: Day, complete: Bool, priority: Int, category: String) -> Task {
		let task = Task.init(context: persistentContainer.viewContext)
		task.create(context: persistentContainer.viewContext, idNum: 0, taskName: "Test High Priority Task", categoryName: category, createdAt: Date(), reminderDate: Date(), priority: priority)
		task.complete = complete
		return task
	}
	
	func awardMatcher(awards: [DailyAccolades.Award], testableAwards: [DailyAccolades.Award]) -> Bool {
		for award in awards {
			if (!testableAwards.contains(award)) {
				return false
			}
		}
		return true
	}
	
	
	// Test completed tasks awards
	
	// High priority awards
	// Because we resolve all awards, we will have completed task awards and high priority awards
	// category awards are not counted for uncategorized tasks
	func testHighPriorityAndCompletedAward() {
		// create mock day
		let day = createMockDayObject()
		
		// create mock tasks
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.high.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.high.rawValue)))
		day.totalTasks = Int16(day.dayToTask?.count ?? 0)
		
		guard let tasks = day.dayToTask as? Set<Task> else { return }
		for task in tasks {
			if (task.complete) {
				day.totalCompleted = day.totalCompleted + 1
			}
		}
		
		let accolades = DailyAccolades(day: day)
		let awards = accolades.retrieveAwards()
		
		let containsAllHighPriorityAwards = awards.contains(AwardsList.HighPriority.ThePresident) && awards.contains(AwardsList.HighPriority.TheTopBrass) && awards.contains(AwardsList.HighPriority.TheBoss)
		
		let containsCompleteTasks = awards.contains(AwardsList.Complete.TheExecutor)
		
		XCTAssertTrue(containsAllHighPriorityAwards && containsCompleteTasks, "Contains all the high priority awards")
	}
	
	// Contains less than 30% compeleted tasks and a high priority task complete
	func testLowCompletionRateAndHighPriority() {
		// create mock day
		let day = createMockDayObject()
		
		// create mock tasks
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.medium.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.low.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.low.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.high.rawValue)))
		
		day.totalTasks = Int16(day.dayToTask?.count ?? 0)
		
		guard let tasks = day.dayToTask as? Set<Task> else { return }
		for task in tasks {
			if (task.complete) {
				day.totalCompleted = day.totalCompleted + 1
			}
		}
		
		let accolades = DailyAccolades(day: day)
		let awards = accolades.retrieveAwards()
		let testAwards: [String] = [
			AwardsList.Complete.TheGoGetter,
			AwardsList.Complete.TheDoer,
			AwardsList.HighPriority.ThePresident,
			AwardsList.HighPriority.TheTopBrass,
			AwardsList.HighPriority.TheBoss
		]
		
		let containsCompleteTasks = awardMatcher(awards: awards, testableAwards: testAwards)

		let awardCorrectCount: Bool = awards.count == testAwards.count
		print("awards - \(awards)")
		XCTAssertTrue(containsCompleteTasks && awardCorrectCount, "All task completed including all priorities with no incomplete priorities")
	}
	
	// Should contain complete/incomplete and medium priority awards because a high priority task is not complete. 50% compelete rating
	func testMediumPriorityAndCompletedAward() {
		// create mock day
		let day = createMockDayObject()
		
		// create mock tasks
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.medium.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.low.rawValue)))
		day.totalTasks = Int16(day.dayToTask?.count ?? 0)
		
		guard let tasks = day.dayToTask as? Set<Task> else { return }
		for task in tasks {
			if (task.complete) {
				day.totalCompleted = day.totalCompleted + 1
			}
		}
		
		let accolades = DailyAccolades(day: day)
		let awards = accolades.retrieveAwards()
		let testAwards: [String] = [
			AwardsList.MediumPriority.TheWorkHorse,
			AwardsList.MediumPriority.TheSilverMedal,
			AwardsList.MediumPriority.TheTerminator,
			AwardsList.Incomplete.TheUndecided,
			AwardsList.Complete.TheBusyBee,
			AwardsList.Complete.ThePowerHouse,
		]
		print(awards)
		let containsAward = awardMatcher(awards: awards, testableAwards: testAwards)
		let awardCorrectCount: Bool = awards.count == testAwards.count
		XCTAssertTrue(containsAward && awardCorrectCount, "Contains all the medium priority awards")
		
	}
	
	// Should contain 100% task award despite priority and no incomplete awards
	func testAllTaskCompleted() {
		// create mock day
		let day = createMockDayObject()
		
		// create mock tasks
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.medium.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.low.rawValue)))
		day.totalTasks = Int16(day.dayToTask?.count ?? 0)
		
		guard let tasks = day.dayToTask as? Set<Task> else { return }
		for task in tasks {
			if (task.complete) {
				day.totalCompleted = day.totalCompleted + 1
			}
		}
		
		let accolades = DailyAccolades(day: day)
		let awards = accolades.retrieveAwards()
		let testAwards: [String] = [
			AwardsList.LowPriority.TheProcrastinator,
			AwardsList.LowPriority.TheLoafer,
			AwardsList.LowPriority.TheTimeKiller,
			AwardsList.Complete.TheCompletionist
		]
		let containsAward = awardMatcher(awards: awards, testableAwards: testAwards)
		let awardCorrectCount: Bool = awards.count == testAwards.count
		
		XCTAssertTrue(containsAward && awardCorrectCount, "All task completed")
	}
	
	// Should contain 100% task award and no incomplete awards. Since all tasks are complete, we choose to reward the user with the highest priority
	func testAllTaskCompletedWithAllPriorities() {
		// create mock day
		let day = createMockDayObject()
		
		// create mock tasks
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.medium.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.low.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.high.rawValue)))
		day.totalTasks = Int16(day.dayToTask?.count ?? 0)
		
		guard let tasks = day.dayToTask as? Set<Task> else { return }
		for task in tasks {
			if (task.complete) {
				day.totalCompleted = day.totalCompleted + 1
			}
		}
		
		let accolades = DailyAccolades(day: day)
		let awards = accolades.retrieveAwards()
		let testAwards: [String] = [
			AwardsList.Complete.TheCompletionist,
			AwardsList.HighPriority.ThePresident,
			AwardsList.HighPriority.TheTopBrass,
			AwardsList.HighPriority.TheBoss,
		]
		print(awards)
		let containsAward = awardMatcher(awards: awards, testableAwards: testAwards)
		let awardCorrectCount: Bool = awards.count == testAwards.count
		
		XCTAssertTrue(containsAward && awardCorrectCount, "All task completed including all priorities with no incomplete priorities")
	}
	
	// Should contain 75% task award and no incomplete awards. Main focus is to test the priority. In this case we'll should have medium priority rewards, 75% completion rate reward and 1 incomplete task because we did not complete a high priority task
	func testAllTaskCompletedWithMediumPriorityRewards() {
		// create mock day
		let day = createMockDayObject()
		
		// create mock tasks
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.medium.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.low.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.high.rawValue)))
		day.totalTasks = Int16(day.dayToTask?.count ?? 0)
		
		guard let tasks = day.dayToTask as? Set<Task> else { return }
		for task in tasks {
			if (task.complete) {
				day.totalCompleted = day.totalCompleted + 1
			}
		}
		
		let accolades = DailyAccolades(day: day)
		let awards = accolades.retrieveAwards()
		let testAwards: [String] = [
			AwardsList.Complete.TheBusyBee,
			AwardsList.Complete.ThePowerHouse,
			AwardsList.MediumPriority.TheTerminator,
			AwardsList.MediumPriority.TheWorkHorse,
			AwardsList.MediumPriority.TheSilverMedal,
			AwardsList.Incomplete.TheUndecided,
		]
		print(awards)
		let containsAward = awardMatcher(awards: awards, testableAwards: testAwards)
		let awardCorrectCount: Bool = awards.count == testAwards.count
		
		XCTAssertTrue(containsAward && awardCorrectCount, "All task completed including all priorities with no incomplete priorities")
	}

	// TEST INCOMPLETE AWARDS
	
	// Should only have medium awards even though we have two types of priority tasks completed, as we take the highest priority completed task to award the user
	// 50% completion rate - 50% incompletion rate
	func testIncompleteAwardWith50PercentCompletionRate() {
		let day = createMockDayObject()
		
		// create mock tasks
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.medium.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.low.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.high.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.high.rawValue)))
		day.totalTasks = Int16(day.dayToTask?.count ?? 0)
		
		guard let tasks = day.dayToTask as? Set<Task> else { return }
		for task in tasks {
			if (task.complete) {
				day.totalCompleted = day.totalCompleted + 1
			}
		}
		
		let accolades = DailyAccolades(day: day)
		let awards = accolades.retrieveAwards()
		let testAwards: [String] = [
			AwardsList.Incomplete.TheCouchPotato,
			AwardsList.MediumPriority.TheTerminator,
			AwardsList.MediumPriority.TheWorkHorse,
			AwardsList.MediumPriority.TheSilverMedal,
			AwardsList.Complete.TheBusyBee,
			AwardsList.Complete.ThePowerHouse,
			
		]
		print(awards)
		let containsAward = awardMatcher(awards: awards, testableAwards: testAwards)
		let awardCorrectCount: Bool = awards.count == testAwards.count
		
		XCTAssertTrue(containsAward && awardCorrectCount, "All task completed including all priorities with no incomplete priorities")
	}
	
	// Rewards
	// 75% incompletion rate - 25% completion rate
	// 1 priority type - medium
	func testIncompleteAwardWith75PercentCompletionRate() {
		let day = createMockDayObject()
		
		// create mock tasks
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.medium.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.low.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.high.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.high.rawValue)))
		day.totalTasks = Int16(day.dayToTask?.count ?? 0)
		
		guard let tasks = day.dayToTask as? Set<Task> else { return }
		for task in tasks {
			if (task.complete) {
				day.totalCompleted = day.totalCompleted + 1
			}
		}
		
		let accolades = DailyAccolades(day: day)
		let awards = accolades.retrieveAwards()
		let testAwards: [String] = [
			AwardsList.Incomplete.ThePolitician,
			AwardsList.MediumPriority.TheTerminator,
			AwardsList.MediumPriority.TheWorkHorse,
			AwardsList.MediumPriority.TheSilverMedal,
			AwardsList.Complete.TheDoer,
			AwardsList.Complete.TheGoGetter,
		]
		print(awards)
		let containsAward = awardMatcher(awards: awards, testableAwards: testAwards)
		let awardCorrectCount: Bool = awards.count == testAwards.count
		
		XCTAssertTrue(containsAward && awardCorrectCount, "All task completed including all priorities with no incomplete priorities")
	}
	
	// CATEGORY REWARDS
	
	// 75% completion rate
	// 3+ category types complete
	func testCategoryWithThreeCategories() {
		let day = createMockDayObject()
		
		// create mock tasks
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.medium.rawValue), category: "Work"))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.low.rawValue), category: "Work"))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.high.rawValue), category: "Work"))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.high.rawValue), category: "Work"))
		day.totalTasks = Int16(day.dayToTask?.count ?? 0)
		
		guard let tasks = day.dayToTask as? Set<Task> else { return }
		for task in tasks {
			if (task.complete) {
				day.totalCompleted = day.totalCompleted + 1
			}
		}
		
		let accolades = DailyAccolades(day: day)
		let awards = accolades.retrieveAwards()
		let testAwards: [String] = [
			AwardsList.Complete.TheExecutor,
			AwardsList.Complete.TheHustler,
			AwardsList.HighPriority.ThePresident,
			AwardsList.HighPriority.TheTopBrass,
			AwardsList.HighPriority.TheBoss,
			AwardsList.Category.TheSpecialist,
			AwardsList.Category.TheProfessional,
		]
		
		print(awards)
		let containsAward = awardMatcher(awards: awards, testableAwards: testAwards)
		let awardCorrectCount: Bool = awards.count == testAwards.count
		
		XCTAssertTrue(containsAward && awardCorrectCount, "All task completed including all priorities with no incomplete priorities")
	}
	
	// 75% completion rate
	// 5 category types complete
	func testCategoryWithFiveCategories() {
		let day = createMockDayObject()
		
		// create mock tasks
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.medium.rawValue), category: "Work"))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.low.rawValue), category: "Work"))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.high.rawValue), category: "Work"))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.high.rawValue), category: "Work"))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.high.rawValue), category: "Work"))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.high.rawValue), category: "Work"))
		day.totalTasks = Int16(day.dayToTask?.count ?? 0)
		
		guard let tasks = day.dayToTask as? Set<Task> else { return }
		for task in tasks {
			if (task.complete) {
				day.totalCompleted = day.totalCompleted + 1
			}
		}
		
		let accolades = DailyAccolades(day: day)
		let awards = accolades.retrieveAwards()
		let testAwards: [String] = [
			AwardsList.Complete.TheExecutor,
			AwardsList.Complete.TheHustler,
			AwardsList.HighPriority.ThePresident,
			AwardsList.HighPriority.TheTopBrass,
			AwardsList.HighPriority.TheBoss,
			AwardsList.Category.TheIceman,
			AwardsList.Category.TheMaster,
		]
		
		print(awards)
		let containsAward = awardMatcher(awards: awards, testableAwards: testAwards)
		let awardCorrectCount: Bool = awards.count == testAwards.count
		
		XCTAssertTrue(containsAward && awardCorrectCount, "All task completed including all priorities with no incomplete priorities")
	}
}
