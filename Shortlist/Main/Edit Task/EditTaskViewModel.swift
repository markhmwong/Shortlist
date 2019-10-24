//
//  EditTaskViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 23/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class EditTaskViewModel {
	
	// to be refactored
	enum Sections: Int, CaseIterable {
		case Details = 0
		case Label
		case Time
		case Delete
	}
	
	enum DetailsSection: Int, CaseIterable {
		case Name
		case Details
	}
	
	enum TimeSection: Int, CaseIterable {
		case Reminder
	}
	
	enum DeleteSection: Int, CaseIterable {
		case Delete
	}
	
	enum LabelSection: Int, CaseIterable {
		case Category
	}
	
	var cellHeight: CGFloat = 70.0
	
	var task: Task? = nil
	
	var taskNameStr: String? = nil
	
	var taskDescriptionStr: String? = nil
	
	init(with task: Task?) {
		self.task = task
	}
	
	func tableViewTextViewCell(tableView: UITableView, indexPath: IndexPath) -> EditTaskTextViewCell {
		// details or name?
		let cell = EditTaskCellFactory.shared().getEditTaskCellType(tableView: tableView, indexPath: indexPath, cellType: .TextView) as! EditTaskTextViewCell
		cell.nameTextView.textColor = UIColor.white
		cell.nameTextView.text = task?.name ?? "Unknown Task"
		return cell
	}
	
	func tableViewLabelCell(tableView: UITableView, indexPath: IndexPath) -> EditTaskLabelCell {
		let cell = EditTaskCellFactory.shared().getEditTaskCellType(tableView: tableView, indexPath: indexPath, cellType: .Label) as! EditTaskLabelCell
		cell.textLabel?.textColor = UIColor.white
		return cell
	}
	
	func defaultCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		// unknown cell
		let cell = EditTaskCellFactory.shared().getEditTaskCellType(tableView: tableView, indexPath: indexPath, cellType: .DefaultCell)
		cell.textLabel?.textColor = UIColor.white
		cell.textLabel?.text = "Unknown Task"
		return cell
	}
	
	func registerCells(tableView: UITableView) {
		// reminder - time
		tableView.register(EditTaskLabelCell.self, forCellReuseIdentifier: EditTaskCellFactory.shared().labelId)
		tableView.register(EditTaskTextViewCell.self, forCellReuseIdentifier: EditTaskCellFactory.shared().textViewId)
	}

	func updateTaskName(_ persistentContainer: PersistentContainer?, updateWithString nameStr: String) {
		let dayManagedObject = persistentContainer?.fetchDayEntity(forDate: Calendar.current.today()) as! Day
		guard let task = task else { return }
		let taskManagedObject = persistentContainer?.viewContext.object(with: task.objectID) as! Task
		dayManagedObject.removeFromDayToTask(taskManagedObject) // how to update MainViewController's nsfetchedresultscontroller without removing
		taskManagedObject.name = nameStr
		dayManagedObject.addToDayToTask(taskManagedObject)
		persistentContainer?.saveContext()
	}
	
	func updateTaskNameString(name: String, indexPath: IndexPath) {
		
		if let section = Sections.init(rawValue: indexPath.section) {
			switch section {
				case .Details:
					if let row = DetailsSection.init(rawValue: indexPath.row) {
						switch row {
							case .Name:
								taskNameStr = name
							case .Details:
								taskDescriptionStr = name
						}
					}
				default:
					() // do nothing - only applies to textviews which are located in the Details Section
			}
		}
		
		
	}
	
	func onDoneSaveToTaskObject(_ persistentContainer: PersistentContainer?) {
		let dayManagedObject = persistentContainer?.fetchDayEntity(forDate: Calendar.current.today()) as! Day
		guard let task = task else { return }
		let taskManagedObject = persistentContainer?.viewContext.object(with: task.objectID) as! Task
		dayManagedObject.removeFromDayToTask(taskManagedObject) // how to update MainViewController's nsfetchedresultscontroller without removing
		
		// save details
		if let taskName = taskNameStr {
			taskManagedObject.name = taskName
		}

		if let taskDescription = taskDescriptionStr {
			taskManagedObject.details = taskDescription
		}
		
		// save reminder
		
		
		// save label
		
		
		dayManagedObject.addToDayToTask(taskManagedObject)
		persistentContainer?.saveContext()
	}
}

