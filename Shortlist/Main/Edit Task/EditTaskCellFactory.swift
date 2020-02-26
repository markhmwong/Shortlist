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
	case PickerView
	case Label
	case Toggle
	case Disclaimer
	case Priority
	case DefaultCell
}

class EditTaskCellFactory {
	
	private static var sharedFactory = EditTaskCellFactory()
	
	let textViewId = "EditTaskTextViewCellId"
	
	let pickerViewId = "EditTaskTimeCellId"
	
	let labelId = "EditTaskLabelCellId"
	
	let toggleId = "EditTaskToggelCellId"
	
	let disclaimerId = "EditTaskDisclaimerCellId"
	
	let priorityId = "EditTaskPriorityCellId"
	
	class func shared() -> EditTaskCellFactory {
		return sharedFactory
	}
	
	func getEditTaskCellType(tableView: UITableView, indexPath: IndexPath, cellType: EditTaskCellType) -> UITableViewCell {
		switch cellType {
			case .TextView:
				let cell = tableView.dequeueReusableCell(withIdentifier: textViewId, for: indexPath)
				return cell
			case .PickerView:
				let cell = tableView.dequeueReusableCell(withIdentifier: pickerViewId, for: indexPath)
				return cell
			case .Toggle:
				let cell = tableView.dequeueReusableCell(withIdentifier: toggleId, for: indexPath)
				return cell
			case .Label:
				let cell = tableView.dequeueReusableCell(withIdentifier: labelId, for: indexPath)
				return cell
			case .Disclaimer:
				let cell = tableView.dequeueReusableCell(withIdentifier: disclaimerId, for: indexPath)
				cell.textLabel?.textColor = UIColor.white.adjust(by: -30.0)
				cell.textLabel?.numberOfLines = 0
				cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
				cell.textLabel?.font = UIFont(name: Theme.Font.Bold, size: Theme.Font.StandardSizes.b3.rawValue)
				cell.isUserInteractionEnabled = false
				return cell
			case .Priority:
				let cell = EditTaskPriorityCell.init(style: .default, reuseIdentifier: priorityId)
				return cell
			case .DefaultCell:
				let cell = tableView.dequeueReusableCell(withIdentifier: textViewId, for: indexPath)
				return cell
		}
	}
}
