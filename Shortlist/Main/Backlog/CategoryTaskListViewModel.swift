//
//  CategoryTaskListViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 8/11/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class CategoryTaskListViewModel {
	
	let cellId = "ReviewCellId"
	
	var categoryName: String?
	
	var sortedData: [Task]?
	
	var selectedTasksToCopy: [Task]?
	

	
	init(categoryName: String?) {
		self.categoryName = categoryName
	}
	
	func initaliseData(data: Set<Task>) {
		sortedData = data.sorted { (taskA, taskB) -> Bool in
			return taskA.name! > taskB.name!
		}
	}
	
	func tableViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
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

}
