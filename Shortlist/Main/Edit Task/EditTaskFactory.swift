//
//  EditTaskFactory.swift
//  Shortlist
//
//  Created by Mark Wong on 25/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

enum EditTaskCellType: Int {
	case TextView
	case Time
	case Label
	case DefaultCell
}

class EditTaskCellFactory {
	
	private static var sharedFactory = EditTaskCellFactory()
	
	let textViewId = "EditTaskTextViewCellId"
	
	let timeId = "EditTaskTimeCellId"
	
	let labelId = "EditTaskLabelCellId"
	
	class func shared() -> EditTaskCellFactory {
		return sharedFactory
	}
	
	func getEditTaskCellType(tableView: UITableView, indexPath: IndexPath, cellType: EditTaskCellType) -> UITableViewCell {
		switch cellType {
			case .TextView:
				let cell = tableView.dequeueReusableCell(withIdentifier: textViewId, for: indexPath)
				cell.backgroundColor = UIColor.clear
				return cell
			case .Time:
				let cell = tableView.dequeueReusableCell(withIdentifier: timeId, for: indexPath)
				cell.backgroundColor = UIColor.yellow
				return cell
			case .Label:
				let cell = tableView.dequeueReusableCell(withIdentifier: labelId, for: indexPath)
				cell.backgroundColor = UIColor.clear
				return cell
			case .DefaultCell:
				let cell = tableView.dequeueReusableCell(withIdentifier: textViewId, for: indexPath)
				cell.backgroundColor = UIColor.yellow
				return cell
		}
	}
}
