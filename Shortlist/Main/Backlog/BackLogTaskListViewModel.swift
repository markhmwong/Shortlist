//
//  CategoryTaskListViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 8/11/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class BackLogTaskListViewModel {
	
	let cellId = "TaskListCellId"
	
	var categoryName: String?
	
	init(categoryName: String?) {
		self.categoryName = categoryName
	}
	
	func tableViewCell(_ tableView: UITableView, indexPath: IndexPath, data: BigListTask) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BackLogTaskListTableViewCell
		cell.textLabel!.text = data.name
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
	
}

class BackLogTaskListTableViewCell: UITableViewCell, CellProtocol {
	
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
