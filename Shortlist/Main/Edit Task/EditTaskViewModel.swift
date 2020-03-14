//
//  EditTaskViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 23/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

enum EditTaskSections: Int, CaseIterable {
	case Details = 0
	case Priority
	case Label // category of task
	case Reminder
	case Delete
}

class EditTaskViewModel {
	
	let sectionTitles = [
		"Details",
		"Priority",
		"Label",
		"Reminder",
		"Delete",
	]
	
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
	
	let cellHeight: CGFloat = 70.0
	
	var task: Task? = nil {
		didSet {
			//not triggering
			reminderToggle = task?.reminderState ?? false
			taskNameStr = task?.name
			priorityLevel = Priority(rawValue: task?.priority ?? 1)!
		}
	}
	
	var taskNameStr: String? = nil
	
	var taskDescriptionStr: String? = nil
	
	var keyboardSize: CGSize = .zero
	
	var reminderDate: Date?
	
	var reminderToggle: Bool = false
	
	var priorityLevel: Priority = .medium
	
	private let sections: Int = 4
	
	init(with task: Task?) {
		// deferred so the didSet closure will trigger
		defer {
			self.task = task
		}
	}
	
	func numberOfSections() -> Int {
		return EditTaskSections.allCases.count
	}
	
	func tableViewTextViewCell(tableView: UITableView, indexPath: IndexPath, fontSize: CGFloat = Theme.Font.FontSize.Standard(.b0).value) -> EditTaskTextViewCell {
		let cell = EditTaskCellFactory.shared().getEditTaskCellType(tableView: tableView, indexPath: indexPath, cellType: .TextView) as! EditTaskTextViewCell
		cell.inputTextView.textColor = Theme.Font.DefaultColor
		cell.inputTextView.text = task?.name ?? "Unknown Task"
		cell.size = fontSize
		return cell
	}
	
	func tableViewPickerViewCell(tableView: UITableView, indexPath: IndexPath) -> EditTaskPickerViewCell {
		let cell = EditTaskCellFactory.shared().getEditTaskCellType(tableView: tableView, indexPath: indexPath, cellType: .PickerView) as! EditTaskPickerViewCell
		return cell
	}
	
	func tableViewLabelCell(tableView: UITableView, indexPath: IndexPath) -> EditTaskLabelCell {
		let cell = EditTaskCellFactory.shared().getEditTaskCellType(tableView: tableView, indexPath: indexPath, cellType: .Label) as! EditTaskLabelCell
		cell.textLabel?.textColor = Theme.Font.DefaultColor
		return cell
	}
	
	func tableViewDisclaimerCell(tableView: UITableView, indexPath: IndexPath) -> EditTaskDisclaimerCell {
		let cell = EditTaskCellFactory.shared().getEditTaskCellType(tableView: tableView, indexPath: indexPath, cellType: .Disclaimer) as! EditTaskDisclaimerCell
		return cell
	}
	
	func tableViewToggle(tableView: UITableView, indexPath: IndexPath) -> EditTaskToggleCell {
		let cell: EditTaskToggleCell = EditTaskCellFactory.shared().getEditTaskCellType(tableView: tableView, indexPath: indexPath, cellType: .Toggle) as! EditTaskToggleCell
		return cell
	}
	
	func tableViewPriorityCell(tableView: UITableView, indexPath: IndexPath) -> EditTaskPriorityCell {
		let cell: EditTaskPriorityCell = EditTaskCellFactory.shared().getEditTaskCellType(tableView: tableView, indexPath: indexPath, cellType: .Priority) as! EditTaskPriorityCell
		cell.viewModel = self
		return cell
	}
	
	// A default cell to fall back on to when all else fails
	func defaultCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		// unknown cell
		let cell = EditTaskCellFactory.shared().getEditTaskCellType(tableView: tableView, indexPath: indexPath, cellType: .DefaultCell)
		cell.textLabel?.textColor = Theme.Font.DefaultColor
		cell.textLabel?.text = "Unknown Task" // possible error in viewmodel not being initialised
		return cell
	}
	
	func registerCells(tableView: UITableView) {
		// reminder - time
		tableView.register(EditTaskLabelCell.self, forCellReuseIdentifier: EditTaskCellFactory.shared().labelId)
		tableView.register(EditTaskTextViewCell.self, forCellReuseIdentifier: EditTaskCellFactory.shared().textViewId)
		tableView.register(EditTaskPickerViewCell.self, forCellReuseIdentifier: EditTaskCellFactory.shared().pickerViewId)
		tableView.register(EditTaskToggleCell.self, forCellReuseIdentifier: EditTaskCellFactory.shared().toggleId)
		tableView.register(EditTaskDisclaimerCell.self, forCellReuseIdentifier: EditTaskCellFactory.shared().disclaimerId)
		tableView.register(EditTaskPriorityCell.self, forCellReuseIdentifier: EditTaskCellFactory.shared().priorityId)
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
		if let section = EditTaskSections.init(rawValue: indexPath.section) {
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
		
		guard let task = task else { return }
		let taskManagedObject = persistentContainer?.viewContext.object(with: task.objectID) as! Task
		// save details
		guard let taskName = taskNameStr else { return }
		taskManagedObject.name = taskName

		if let taskDescription = taskDescriptionStr {
			taskManagedObject.details = taskDescription
		}
		
		taskManagedObject.reminderState = reminderToggle
		taskManagedObject.priority = priorityLevel.value
		
		if let date = reminderDate {
			taskManagedObject.reminder = date as NSDate
			// local notification
			LocalNotificationsService.shared.addReminderNotification(dateIdentifier: taskManagedObject.createdAt! as Date, notificationContent: [LocalNotificationKeys.Title : taskName], timeRemaining: date.timeIntervalSince(Date()))
		}
		persistentContainer?.saveContext()
	}
}

