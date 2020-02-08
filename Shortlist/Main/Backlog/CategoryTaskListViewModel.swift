//
//  CategoryTaskListViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 8/11/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class CategoryTaskListViewModel {
	
	let cellId = "TaskListCellId"
	
	var categoryName: String?
	
	var sortedData: [BigListTask]?
	
	init(categoryName: String?) {
		self.categoryName = categoryName
	}
	
	func initaliseData(data: Set<BigListTask>) {
		sortedData = data.sorted { (taskA, taskB) -> Bool in
			return taskA.name! > taskB.name!
		}
	}
	
	func tableViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BackLogTaskListTableViewCell
		
		guard let _sortedData = sortedData else {
			cell.textLabel!.text = "Unknown Task"
			return cell
		}
		
		cell.textLabel!.text = _sortedData[indexPath.row].name
		return cell
	}
	
	func registerTableViewCell(_ tableView: UITableView) {
		tableView.register(BackLogTaskListTableViewCell.self, forCellReuseIdentifier: cellId)
	}
	
	func tableViewErrorCell(_ tableView: UITableView, indexPath: IndexPath) -> CategoryCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! CategoryCell
		cell.textLabel?.text = "Unknown Cell"
		return cell
	}
	
	func tableCellAt(tableView: UITableView, indexPath: IndexPath) -> BackLogTaskListTableViewCell {
		let cell = tableView.cellForRow(at: indexPath) as! BackLogTaskListTableViewCell
		guard cell.task != nil else {
			cell.task = nil
            return cell
        }
		return cell
	}
	
}

class BackLogTaskListTableViewCell: UITableViewCell, CellProtocol {
	
	var task : Task?
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupCellLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupCellLayout() {
		backgroundColor = .clear
		textLabel?.textColor = UIColor.white
		layer.cornerRadius = 10.0
//		layer.backgroundColor = UIColor.red.cgColor
	}
	
}
