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

//		cell.textLabel!.text = _sortedData[indexPath.row].name
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
	
//	func checkPrioriy(persistentContainer: PersistentContainer?, task: Task?) -> (PriorityLimitThreshold, String) {
//		guard let _pc = persistentContainer else { return (.Exceeded, "Persistent Container Error") }
//		guard let _task = task else { return (.Exceeded, "Task Error") }
//		let today: Date = Calendar.current.today()
//		let todayDayObj: Day = _pc.fetchDayEntity(forDate: today) as! Day
//
//		if let priority = Priority.init(rawValue: _task.priority) {
//			switch priority {
//				case Priority.high:
//					if (todaysPriorityCount[Int(_task.priority)] ?? 0 >= todayDayObj.highPriorityLimit) {
//						return (.Exceeded, "High")
//					}
//				case Priority.medium:
//					if (todaysPriorityCount[Int(_task.priority)] ?? 0 >= todayDayObj.mediumPriorityLimit) {
//						return (.Exceeded, "Medium")
//					}
//				case Priority.low:
//					if (todaysPriorityCount[Int(_task.priority)] ?? 0 >= todayDayObj.lowPriorityLimit) {
//						return (.Exceeded, "Low")
//					}
//				case Priority.none:
//					return (.Exceeded, "None")
//			}
//		}
//
//		return (.WithinLimit, "Sucess")
//	}
	
//	func resolvePriorityCount(persistentContainer: PersistentContainer) {
//		guard let _dayEntity = dayEntity else { return }
//		let today: Date = Calendar.current.today()
//		let todayDayObj: Day = persistentContainer.fetchDayEntity(forDate: today) as! Day
//
//		let tasks = _dayEntity.dayToTask as! Set<Task>
//		let todayTasks = todayDayObj.dayToTask as! Set<Task>
//
//		for task in tasks {
//			priorityCount[Int(task.priority)] = (priorityCount[Int(task.priority)] ?? 0) + 1
//		}
//
//		for task in todayTasks {
//			todaysPriorityCount[Int(task.priority)] = (todaysPriorityCount[Int(task.priority)] ?? 0) + 1
//		}
//	}
}

