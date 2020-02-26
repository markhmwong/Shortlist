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

        day.month = Calendar.current.monthToInt() // Stats
        day.year = Calendar.current.yearToInt() // Stats
        day.day = Int16(Calendar.current.todayToInt()) // Stats
		
		return day
	}
	
	func createMockTasks(day: Day, complete: Bool, priority: Int) -> Task {
		let task = Task.init(context: persistentContainer.viewContext)
		task.create(context: persistentContainer.viewContext, taskName: "Test High Priority Task", categoryName: "Uncategorized", createdAt: Date(), reminderDate: Date(), priority: priority)
		task.complete = complete
		return task
	}
	
	func createMockTasks(day: Day, complete: Bool, priority: Int, category: String) -> Task {
		let task = Task.init(context: persistentContainer.viewContext)
		task.create(context: persistentContainer.viewContext, taskName: "Test High Priority Task", categoryName: category, createdAt: Date(), reminderDate: Date(), priority: priority)
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
	// Incomplete awards
	// 50% complete
	// category awards are not counted for uncategorized tasks
	func testHighPriorityAndCompletedAward() {
		// create mock day
		let day = Day(context: persistentContainer.viewContext)
		day.createNewDay(date: Calendar.current.today())
		
		// create mock tasks
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.high.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.high.rawValue)))
		guard let dayToStats = day.dayToStats else { return }
		guard let dayToTask = day.dayToTask as? Set<Task> else { return }

		dayToStats.totalTasks = Int64(dayToTask.count)
		
		for task in dayToTask {
			if (task.complete) {
				dayToStats.totalCompleted = dayToStats.totalCompleted + 1
			}
		}
		
		let accolades = DailyAccolades(day: day)
		let awards = accolades.retrieveAwards()
		print(awards)
		let testAwards: [String] = [
			AwardsList.Complete.TheBusyBee,
			AwardsList.Complete.ThePowerHouse,
			AwardsList.HighPriority.ThePresident,
			AwardsList.HighPriority.TheTopBrass,
			AwardsList.Complete.TheGrunt,
			AwardsList.HighPriority.TheBoss
		]
		
		let containsCompleteTasks = awardMatcher(awards: awards, testableAwards: testAwards)
		
		let containsAllHighPriorityAwards = awards.contains(AwardsList.HighPriority.ThePresident) && awards.contains(AwardsList.HighPriority.TheTopBrass) && awards.contains(AwardsList.HighPriority.TheBoss)
		
		XCTAssertTrue(containsAllHighPriorityAwards && containsCompleteTasks, "Contains all the high priority awards")
	}
	
	// Contains less than 30% compeleted tasks and a high priority task complete
	func testLowCompletionRateAndHighPriority() {
		// create mock day
		let day = Day(context: persistentContainer.viewContext)
		day.createNewDay(date: Calendar.current.today())

		// create mock tasks
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.medium.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.low.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.low.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.high.rawValue)))
		guard let dayToStats = day.dayToStats else { return }
		guard let dayToTask = day.dayToTask as? Set<Task> else { return }
		
		dayToStats.totalTasks = Int64(dayToTask.count)

		for task in dayToTask {
			if (task.complete) {
				dayToStats.totalCompleted = dayToStats.totalCompleted + 1
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

//	// Should contain complete/incomplete and medium priority awards because a high priority task is not complete. 50% compelete rating
	func testMediumPriorityAndCompletedAward() {
		// create mock day
		let day = Day(context: persistentContainer.viewContext)
		day.createNewDay(date: Calendar.current.today())

		// create mock tasks
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.medium.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.low.rawValue)))
		
		guard let dayToStats = day.dayToStats else { return }
		guard let dayToTask = day.dayToTask as? Set<Task> else { return }
		
		dayToStats.totalTasks = Int64(dayToTask.count)

		for task in dayToTask {
			if (task.complete) {
				dayToStats.totalCompleted = dayToStats.totalCompleted + 1
			}
		}

		let accolades = DailyAccolades(day: day)
		let awards = accolades.retrieveAwards()
		let testAwards: [String] = [
			AwardsList.MediumPriority.TheWorkHorse,
			AwardsList.MediumPriority.TheSlogger,
			AwardsList.MediumPriority.TheToiler,
			AwardsList.Incomplete.TheCouchPotato,
			AwardsList.Complete.TheBusyBee,
			AwardsList.Complete.TheGrunt,
		]
		print(awards)
		let containsAward = awardMatcher(awards: awards, testableAwards: testAwards)
		let awardCorrectCount: Bool = awards.count == testAwards.count
		XCTAssertTrue(containsAward && awardCorrectCount, "Contains all the medium priority awards")

	}
//
//	// Should contain 100% task award despite priority and no incomplete awards
	func testAllTaskCompleted() {
		// create mock day
		let day = Day(context: persistentContainer.viewContext)
		day.createNewDay(date: Calendar.current.today())

		// create mock tasks
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.medium.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.low.rawValue)))

		guard let dayToStats = day.dayToStats else { return }
		guard let dayToTask = day.dayToTask as? Set<Task> else { return }
		
		dayToStats.totalTasks = Int64(dayToTask.count)

		for task in dayToTask {
			if (task.complete) {
				dayToStats.totalCompleted = dayToStats.totalCompleted + 1
			}
		}

		let accolades = DailyAccolades(day: day)
		let awards = accolades.retrieveAwards()
		print(awards)
		let testAwards: [String] = [
			AwardsList.MediumPriority.TheToiler,
			AwardsList.MediumPriority.TheWorkHorse,
			AwardsList.MediumPriority.TheSlogger,
			AwardsList.Complete.TheCompletionist,
			AwardsList.Complete.TheOneManBand,
			AwardsList.Complete.TheHighAchiever
		]
		let containsAward = awardMatcher(awards: awards, testableAwards: testAwards)
		let awardCorrectCount: Bool = awards.count == testAwards.count

		XCTAssertTrue(containsAward && awardCorrectCount, "All task completed")
	}
//
//	// Should contain 100% task award and no incomplete awards. Since all tasks are complete, we choose to reward the user with the highest priority
	func testAllTaskCompletedWithAllPriorities() {
		// create mock day
		let day = Day(context: persistentContainer.viewContext)
		day.createNewDay(date: Calendar.current.today())

		// create mock tasks
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.medium.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.low.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.high.rawValue)))

		guard let dayToStats = day.dayToStats else { return }
		guard let dayToTask = day.dayToTask as? Set<Task> else { return }
		
		dayToStats.totalTasks = Int64(dayToTask.count)

		for task in dayToTask {
			if (task.complete) {
				dayToStats.totalCompleted = dayToStats.totalCompleted + 1
			}
		}

		let accolades = DailyAccolades(day: day)
		let awards = accolades.retrieveAwards()
		let testAwards: [String] = [
			AwardsList.Complete.TheCompletionist,
			AwardsList.Complete.TheOneManBand,
			AwardsList.Complete.TheHighAchiever,
			AwardsList.HighPriority.ThePresident,
			AwardsList.HighPriority.TheTopBrass,
			AwardsList.HighPriority.TheBoss,
		]
		print(awards)
		let containsAward = awardMatcher(awards: awards, testableAwards: testAwards)
		let awardCorrectCount: Bool = awards.count == testAwards.count

		XCTAssertTrue(containsAward && awardCorrectCount, "All task completed including all priorities with no incomplete priorities")
	}
//
//	// Should contain 75% task award and no incomplete awards. Main focus is to test the priority. In this case we'll should have medium priority rewards, 75% completion rate reward and 1 incomplete task because we did not complete a high priority task
	func testAllTaskCompletedWithMediumPriorityRewards() {
		// create mock day
		let day = Day(context: persistentContainer.viewContext)
		day.createNewDay(date: Calendar.current.today())

		// create mock tasks
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.medium.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.low.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.high.rawValue)))
		
		guard let dayToStats = day.dayToStats else { return }
		guard let dayToTask = day.dayToTask as? Set<Task> else { return }
		
		dayToStats.totalTasks = Int64(dayToTask.count)

		for task in dayToTask {
			if (task.complete) {
				dayToStats.totalCompleted = dayToStats.totalCompleted + 1
			}
		}

		let accolades = DailyAccolades(day: day)
		let awards = accolades.retrieveAwards()
		let testAwards: [String] = [
			AwardsList.Complete.TheBusyBee,
			AwardsList.Complete.TheGrunt,
			AwardsList.MediumPriority.TheToiler,
			AwardsList.MediumPriority.TheWorkHorse,
			AwardsList.MediumPriority.TheSlogger,
			AwardsList.Incomplete.TheCouchPotato,
		]
		print(awards)
		let containsAward = awardMatcher(awards: awards, testableAwards: testAwards)
		let awardCorrectCount: Bool = awards.count == testAwards.count

		XCTAssertTrue(containsAward && awardCorrectCount, "Partially completed including all priorities with no incomplete priorities")
	}
//
//	// TEST INCOMPLETE AWARDS
//
//	// Should only have medium awards even though we have two types of priority tasks completed, as we take the highest priority completed task to award the user
//	// 50% completion rate - 50% incompletion rate
	func testIncompleteAwardWith50PercentCompletionRate() {
		let day = Day(context: persistentContainer.viewContext)
		day.createNewDay(date: Calendar.current.today())

		// create mock tasks
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.medium.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.low.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.high.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.high.rawValue)))
		guard let dayToStats = day.dayToStats else { return }
		guard let dayToTask = day.dayToTask as? Set<Task> else { return }
		
		dayToStats.totalTasks = Int64(dayToTask.count)

		for task in dayToTask {
			if (task.complete) {
				dayToStats.totalCompleted = dayToStats.totalCompleted + 1
			}
		}

		let accolades = DailyAccolades(day: day)
		let awards = accolades.retrieveAwards()
		let testAwards: [String] = [
			AwardsList.Incomplete.TheCouchPotato,
			AwardsList.MediumPriority.TheToiler,
			AwardsList.MediumPriority.TheWorkHorse,
			AwardsList.MediumPriority.TheSlogger,
			AwardsList.Complete.TheBusyBee,
			AwardsList.Complete.TheGrunt,
		]
		let containsAward = awardMatcher(awards: awards, testableAwards: testAwards)
		let awardCorrectCount: Bool = awards.count == testAwards.count

		XCTAssertTrue(containsAward && awardCorrectCount, "Partially completed including all priorities with no incomplete priorities")
	}
//
//	// Rewards
//	// 75% incompletion rate - 25% completion rate
//	// 1 priority type - medium
	func testIncompleteAwardWith75PercentCompletionRate() {
		let day = Day(context: persistentContainer.viewContext)
		day.createNewDay(date: Calendar.current.today())

		// create mock tasks
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.medium.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.low.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.high.rawValue)))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.high.rawValue)))
		guard let dayToStats = day.dayToStats else { return }
		guard let dayToTask = day.dayToTask as? Set<Task> else { return }
		
		dayToStats.totalTasks = Int64(dayToTask.count)

		for task in dayToTask {
			if (task.complete) {
				dayToStats.totalCompleted = dayToStats.totalCompleted + 1
			}
		}

		let accolades = DailyAccolades(day: day)
		let awards = accolades.retrieveAwards()
		let testAwards: [String] = [
			AwardsList.Incomplete.ThePolitician,
			AwardsList.MediumPriority.TheToiler,
			AwardsList.MediumPriority.TheWorkHorse,
			AwardsList.MediumPriority.TheSlogger,
			AwardsList.Complete.TheDoer,
			AwardsList.Complete.TheGoGetter,
		]
		let containsAward = awardMatcher(awards: awards, testableAwards: testAwards)
		let awardCorrectCount: Bool = awards.count == testAwards.count

		XCTAssertTrue(containsAward && awardCorrectCount, "One Task completed including all priorities with no incomplete priorities")
	}
//
//	// CATEGORY REWARDS
//
//	// 75% completion rate
//	// 3+ category types complete
	func testCategoryWithThreeCategories() {
		let day = Day(context: persistentContainer.viewContext)
		day.createNewDay(date: Calendar.current.today())

		// create mock tasks
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.medium.rawValue), category: "Work"))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.low.rawValue), category: "Work"))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.high.rawValue), category: "Work"))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.high.rawValue), category: "Work"))
		guard let dayToStats = day.dayToStats else { return }
		guard let dayToTask = day.dayToTask as? Set<Task> else { return }
		
		dayToStats.totalTasks = Int64(dayToTask.count)

		for task in dayToTask {
			if (task.complete) {
				dayToStats.totalCompleted = dayToStats.totalCompleted + 1
			}
		}

		let accolades = DailyAccolades(day: day)
		let awards = accolades.retrieveAwards()
		let testAwards: [String] = [
			AwardsList.Complete.ThePowerHouse,
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

		XCTAssertTrue(containsAward && awardCorrectCount, "3 / 4 completed tasks including all priorities with no incomplete priorities")
	}
//
//	// 75% completion rate
//	// 5 category types complete
	func testCategoryWithFiveCategories() {
		let day = Day(context: persistentContainer.viewContext)
		day.createNewDay(date: Calendar.current.today())

		// create mock tasks
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.medium.rawValue), category: "Work"))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.low.rawValue), category: "Work"))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.high.rawValue), category: "Work"))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.high.rawValue), category: "Work"))
		day.addToDayToTask(createMockTasks(day: day, complete: true, priority: Int(Priority.high.rawValue), category: "Work"))
		day.addToDayToTask(createMockTasks(day: day, complete: false, priority: Int(Priority.high.rawValue), category: "Work"))
		guard let dayToStats = day.dayToStats else { return }
		guard let dayToTask = day.dayToTask as? Set<Task> else { return }
		
		dayToStats.totalTasks = Int64(dayToTask.count)

		for task in dayToTask {
			if (task.complete) {
				dayToStats.totalCompleted = dayToStats.totalCompleted + 1
			}
		}

		let accolades = DailyAccolades(day: day)
		let awards = accolades.retrieveAwards()
		let testAwards: [String] = [
			AwardsList.Complete.ThePowerHouse,
			AwardsList.Complete.TheExecutor,
			AwardsList.Complete.TheHustler,
			AwardsList.HighPriority.ThePresident,
			AwardsList.HighPriority.TheTopBrass,
			AwardsList.HighPriority.TheBoss,
			AwardsList.Category.TheIceman,
			AwardsList.Category.TheMaster,
		]

		let containsAward = awardMatcher(awards: awards, testableAwards: testAwards)
		let awardCorrectCount: Bool = awards.count == testAwards.count

		XCTAssertTrue(containsAward && awardCorrectCount, "90%+ completed including all priorities with no incomplete priorities")
	}
}
