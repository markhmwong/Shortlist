//
//  Accolades.swift
//  Shortlist
//
//  Created by Mark Wong on 29/12/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation


class DailyAccolades: NSObject {
	
	typealias PriorityLevel = Int
	typealias Amount = Int
	typealias Award = String
	
	private let task: Set<Task>?
	
	
	private var awardList: [Award] = []

	private var priorityTracker: [PriorityLevel : Amount] = [:]
	
	private var categoryTracker: [String : Int] = [:]
	
	private var day: Day?
	
	private var hasHighPriorityTaskBeenCompleted: Bool = false
	
	init(day: Day) {
		self.day = day
		self.task = day.dayToTask as? Set<Task>
		super.init()
		resolveAllAwards()
	}
	
	// how to decide which award has priority - randomly selected from array
	// shuffle first, randomly pick top 3
	private func resolveAllAwards() {
		resolveCompleteTasks()
		resolveTaskPriorityAward()
		resolveCategoryAward()
		
		// To help the user feel good and continue using the app
		// we want to avoid anything that may deter them from being productive
		// rather we want to encourage them to keep going, so we'll leave these
		// awards out if they haven't done a high priority task
		guard let _stats = day?.dayToStats else {
			awardList.append(AwardsList.Incomplete.TheUndecided)
			return
		}
		if (!hasHighPriorityTaskBeenCompleted && (Double(_stats.totalCompleted) / Double(_stats.totalTasks)) != 1.0) {
			resolveIncompleteTasks()
		}
		
		if (awardList.isEmpty) {
			awardList.append(AwardsList.Incomplete.TheUndecided)
		}
	}
	
	private func resolveCompleteTasks() {
		guard let _stats = day?.dayToStats else { return }
		
		if (_stats.totalCompleted == _stats.totalTasks && _stats.totalCompleted != 0) {
			awardList.append(AwardsList.Complete.TheCompletionist)
			awardList.append(AwardsList.Complete.TheOneManBand)
			awardList.append(AwardsList.Complete.TheHighAchiever)
			return
		}
		
		// to be updated with correct awards
		
		let percentageComplete: Double = Double(_stats.totalCompleted) / Double(_stats.totalTasks)
		
		if (percentageComplete > 0.01 && percentageComplete < 0.3) {
			awardList.append(AwardsList.Complete.TheDoer)
			awardList.append(AwardsList.Complete.TheGoGetter)
		} else if (percentageComplete >= 0.3 && percentageComplete < 0.7) {
			awardList.append(AwardsList.Complete.TheBusyBee)
			awardList.append(AwardsList.Complete.TheGrunt)
		} else if (percentageComplete >= 0.7) {
			awardList.append(AwardsList.Complete.ThePowerHouse)
			awardList.append(AwardsList.Complete.TheExecutor)
			awardList.append(AwardsList.Complete.TheHustler)
		}
	}
	
	private func resolveIncompleteTasks() {
		guard let _stats = day?.dayToStats else { return }
		let incompleteTasks = _stats.totalTasks - _stats.totalCompleted
		
		if (_stats.totalTasks == 0) {
			awardList.append(AwardsList.Incomplete.TheFunday)
		}
		
		let percentageIncomplete: Double = Double(incompleteTasks) / Double(_stats.totalTasks)
		
		if (percentageIncomplete >= 0.0 && percentageIncomplete < 0.3) {
			awardList.append(AwardsList.Incomplete.TheUndecided)
		} else if (percentageIncomplete >= 0.3 && percentageIncomplete < 0.7) {
			awardList.append(AwardsList.Incomplete.TheCouchPotato)
		} else if (percentageIncomplete >= 0.7 && percentageIncomplete < 0.9) {
			awardList.append(AwardsList.Incomplete.ThePolitician)
		} else if (percentageIncomplete >= 0.9) {
			awardList.append(AwardsList.Incomplete.TheDayDreamer)
		}
	}
	
	private func resolveTaskPriorityAward() {
		guard let _task = task else { return }

		// track highest priority task
		for t in _task {
			if (t.complete) {
				priorityTracker[Int(t.priority)] = (priorityTracker[Int(t.priority)] ?? 0) + 1
				if (Priority.high.value == t.priority) {
					hasHighPriorityTaskBeenCompleted = true
				}
			}
		}
		
		guard let maxPriority = priorityTracker.keys.min() else { return }
		
		// we choose the highest priority
		
		if let p = Priority.init(rawValue: Int16(maxPriority)) {
			switch p {
				case .high:
					awardList.append(AwardsList.HighPriority.ThePresident)
					awardList.append(AwardsList.HighPriority.TheTopBrass)
					awardList.append(AwardsList.HighPriority.TheBoss)
				case .medium:
					awardList.append(AwardsList.MediumPriority.TheToiler)
					awardList.append(AwardsList.MediumPriority.TheWorkHorse)
					awardList.append(AwardsList.MediumPriority.TheSlogger)
				case .low:
					awardList.append(AwardsList.LowPriority.TheProcrastinator)
					awardList.append(AwardsList.LowPriority.TheLoafer)
					awardList.append(AwardsList.LowPriority.TheTimeKiller)
				case .none:
					()
			}
		}
	}
	
	// Not counting the uncategorized category
	private func resolveCategoryAward() {
		guard let _task = task else { return }
		// track highest most category complete
		for t in _task {
			if (t.complete && t.category != "General") {
				categoryTracker[t.category ?? "General"] = (categoryTracker[t.category ?? "General"] ?? 0) + 1
			}
		}
		if let maxValue = categoryTracker.values.max() {
			if maxValue >= 3 && maxValue < 5 {
				awardList.append(AwardsList.Category.TheSpecialist)
				awardList.append(AwardsList.Category.TheProfessional)
			} else if (maxValue >= 5) {
				awardList.append(AwardsList.Category.TheIceman)
				awardList.append(AwardsList.Category.TheMaster)
			}
		}
		
		guard let _stats = day?.dayToStats else { return }
		
		if (_stats.totalCompleted == _stats.totalTasks) {
			if let maxValue = categoryTracker.values.max() {
				if maxValue == 1 {
					awardList.append(AwardsList.Category.TheGeneralist)
					awardList.append(AwardsList.Category.TheRenaissanceMan)
					awardList.append(AwardsList.Category.TheFactotum)
				}
			}
		}
	}
	
	// Award is a typealias of type String
	func evaluateFinalAward() -> Award {
		let max = awardList.count
		let num = Int.random(in: 0..<max)
		return awardList[num]
	}
	
	// unit tests
	func retrieveAwards() -> [Award] {
		return awardList
	}
}
