//
//  MainViewModel.swift
//  Five
//
//  Created by Mark Wong on 16/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class MainViewModel {
    
    let taskListCellId = "taskCellId"
    
    var dayEntity: Day? = nil //{
    
    let taskSizeLimit: Int = 100
    
    let cellHeight: CGFloat = 70.0
	
	var category: String? = ""
	
	func taskForRow(_ tasks: [Task]?, indexPath: IndexPath) -> Task? {		
		guard let tasks = tasks else { return nil }
		return tasks[indexPath.row]
	}
	
	func sortTasks(_ day: Day) -> [Task]? {
		let set = day.dayToTask as? Set<Task>
		if (!set!.isEmpty) {
            return set?.sorted(by: { (taskA, taskB) -> Bool in
                return taskA.priority < taskB.priority
            })
		} else {
			return nil
		}
	}
	
	func registerCell(_ tableView: UITableView) {
        tableView.register(TaskCell.self, forCellReuseIdentifier: taskListCellId)
	}
	
	func tableViewCell(_ tableView: UITableView, indexPath: IndexPath) -> TaskCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: taskListCellId, for: indexPath) as! TaskCell
		
		if (indexPath.row == 0) {
			cell.setupCellLayout(indexPath.row)
			cell.backgroundColor = UIColor(red:0.29, green:0.08, blue:0.02, alpha:1.0)
		} else {
			cell.setupCellLayout(indexPath.row)
		}
		
		return cell
	}
	
}
