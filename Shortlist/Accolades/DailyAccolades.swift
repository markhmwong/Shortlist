//
//  Accolades.swift
//  Shortlist
//
//  Created by Mark Wong on 29/12/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation


class DailyAccolades: NSObject {
	
	let task: Set<Task>?
	
	typealias Award = String
	var awardList: [Award] = []
	
	typealias Priority = Int
	typealias Amount = Int
	
	var priorityTracker: [Priority : Amount] = [:]
	
	var categoryTracker: [String : Int] = [:]
	
	var day: Day?
	
	init(day: Day) {
		self.day = day
		self.task = day.dayToTask as? Set<Task>
		super.init()
		
		resolveIncompleteTasks()
		
		resolveFinalAward()
	}
	
	// how to decide which award has priority - randomly selected from array
	// shuffle first, randomly pick top 3
	func resolveFinalAward() {
		

	}
	
	private func resolveCompleteTasks() {
		guard let _day = day else { return }
		
		if (_day.totalCompleted == _day.totalTasks) {
			awardList.append(AwardsList.Complete.TheCompletionist)
			return
		}
		
		if (_day.totalCompleted > 1 && _day.totalCompleted <= 2) {
			awardList.append(AwardsList.Complete.TheDoer)
		} else if (_day.totalCompleted > 2 && _day.totalCompleted <= 4) {
			awardList.append(AwardsList.Complete.TheDoer)

		}
		
		

	}
	
	private func resolveIncompleteTasks() {
		guard let _day = day else { return }
		let incompleteTasks = _day.totalTasks - _day.totalCompleted
		
		if (incompleteTasks <= 2 && incompleteTasks > 0) {
			awardList.append(AwardsList.Incomplete.TheFunday)
		} else if (incompleteTasks > 2 && incompleteTasks <= 5) {
			awardList.append(AwardsList.Incomplete.TheCouchPotato)
		} else if (incompleteTasks > 5 && incompleteTasks <= 8) {
			awardList.append(AwardsList.Incomplete.ThePolitician)
		} else if (incompleteTasks > 9) {
			awardList.append(AwardsList.Incomplete.TheDayDreamer)
		} else {
			() // no award for all other circumstances
		}
		
	}
	
	private func resolveTaskPriorityAward() {
		guard let _task = task else { return }

		// track highest priority task
		for t in _task {
			if (t.complete) {
				priorityTracker[Int(t.priority)] = (priorityTracker[Int(t.priority)] ?? 0) + 1
			} else {
				priorityTracker[Int(t.priority)] = (priorityTracker[Int(t.priority)] ?? 0) + 1
			}
		}
	}
	
	private func resolveCategoryAward() {
		guard let _task = task else { return }
		// track highest most category complete
		for t in _task {
			if (t.complete && t.category != "Uncategorized") {
				categoryTracker[t.category] = (categoryTracker[t.category] ?? 0) + 1
			}
		}
	}
	
}
