//
//  CategoryTaskListViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 8/11/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class CategoryTaskListViewModel {
	
	private let cellId = "ReviewCellId"
	
	var categoryName: String?
	
	private var sortedData: [Task]?
	
	private var selectedTasksToCopy: [Task]?
	
	typealias PriorityType = Int
	
	private var todaysPriorityCount: [PriorityType : Int] = [:]

	
	init(categoryName: String?) {
		self.categoryName = categoryName
	}
	
	func initaliseData(data: Set<Task>) {
		sortedData = data.sorted { (taskA, taskB) -> Bool in
			return taskA.name! > taskB.name!
		}
	}
	
	func tableViewCell(_ tableView: UITableView, indexPath: IndexPath) -> ReviewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ReviewCell
		guard let _sortedData = sortedData else {
			cell.textLabel!.text = "Unknown Task"
			return cell
		}
		cell.task = _sortedData[indexPath.row]
		return cell
	}
	
	func registerTableViewCell(_ tableView: UITableView) {
		tableView.register(ReviewCell.self, forCellReuseIdentifier: cellId)
	}
	
	func tableViewErrorCell(_ tableView: UITableView, indexPath: IndexPath) -> ReviewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! ReviewCell
		cell.textLabel?.text = "Unknown Cell"
		return cell
	}
	
	func tableCellAt(tableView: UITableView, indexPath: IndexPath) -> ReviewCell {
		let cell = tableView.cellForRow(at: indexPath) as! ReviewCell
		guard cell.task != nil else {
			cell.task = nil
            return cell
        }
		return cell
	}
	
	// Duplicate
	// A check for the priority limit. Do not allow the user to carry over another task with the same priority type if it has exceeded the daily limit. They can however change their daily limit to allow for it
	// returns Tuple. The String in the tuple is the priority type in letters
	func checkPriority(persistentContainer: PersistentContainer?, task: Task?, completionHandler: ((PriorityLimitThreshold, String)) -> ()) -> Void {
		var (threshold, message): (PriorityLimitThreshold, String) = (.WithinLimit, "None")
		
		guard let _pc = persistentContainer else {
			completionHandler((.Exceeded, "Persistent Container Error"))
			return
		}
		
		guard let _task = task else {
			completionHandler((.Exceeded, "Task Error"))
			return
		}
		
		let today: Date = Calendar.current.today()
		let todayDayObj: Day = _pc.fetchDayEntity(forDate: today) as! Day
		let totalTasks = totalTasksForPriority(todayDayObj, priorityLevel: Int(_task.priority))

		if let p = Priority.init(rawValue: _task.priority) {
			switch p {
				case .high:
					if (totalTasks >= KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.HighPriorityLimit) ?? totalTasks) {
						// warning
						(threshold, message) = (.Exceeded, "High")
					}
				case .medium:
					if (totalTasks >= KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.MediumPriorityLimit) ?? totalTasks) {
						(threshold, message) = (.Exceeded, "Medium")
					}
				case .low:
					if (totalTasks >= KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.LowPriorityLimit) ?? totalTasks) {
						// warning
						(threshold, message) = (.Exceeded, "Low")
						return
					}
				case .none:
					(threshold, message) = (.Exceeded, "None")
			}
		}
		completionHandler((threshold, message))
	}
	
	// In conjunction with the checkPriority() method
	func totalTasksForPriority(_ day: Day, priorityLevel: Int) -> Int {
		guard let set = sortTasks(day) else {
			return 0
		}
		
		var numberOfPriorityTasks = 0
		for task in set {
			if (priorityLevel == task.priority) {
				numberOfPriorityTasks = numberOfPriorityTasks + 1
			}
		}
		
		return numberOfPriorityTasks
	}
	
	func sortTasks(_ day: Day) -> [Task]? {
		return day.sortTasks()
	}
}

