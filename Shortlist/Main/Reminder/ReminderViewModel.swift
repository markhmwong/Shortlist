//
//  ReminderViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 31/3/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import EventKit

class ReminderViewModel {
	private var diffDatasource: UITableViewDiffableDataSource<ReminderSection, EKReminder>?
	
	private var cellId: String = "ReminderCellId"
	
	private var ekReminders: [EKReminder]? = []
	
	private var selectedReminders: [Int] = []
	
	private var maxQuoteIndex: Int = 0
	
	func reminderFor(row: Int) -> EKReminder {
		guard let ekReminders = ekReminders else {
			let r = EKReminder()
			r.title = "Unknown Reminder"
			return r
		}
		return ekReminders[row]
	}
	
	func registerCells(_ tableView: UITableView) {
		tableView.register(ReminderCell.self, forCellReuseIdentifier: cellId)
	}
	
	func reminderAtTableViewCell(indexPath: IndexPath) -> EKReminder? {
		guard let reminder = diffDatasource?.itemIdentifier(for: indexPath) else { return nil }
		return reminder
	}
	
	func setCellForTableView(_ tableView: UITableView, indexPath: IndexPath, ekReminder: EKReminder) -> ReminderCell {
		let cell: ReminderCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ReminderCell
		cell.setupCell()
		cell.reminder = ekReminder
		cell.detailTextLabel?.text = ekReminder.calendar.title
		cell.detailTextLabel?.textColor = Theme.Font.DefaultColor
		return cell
	}
	
	func configureDiffableDatasource(tableView: UITableView) {
		
		diffDatasource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, ekReminder) -> UITableViewCell? in
			self.setCellForTableView(tableView, indexPath: indexPath, ekReminder: ekReminder)
		})
	}
	
	func updateDatasourceSnapshot() {
		guard let ekReminders = ekReminders, let diffDatasource = diffDatasource else { return }
	
		var snapshot = NSDiffableDataSourceSnapshot<ReminderSection, EKReminder>()
		snapshot.appendSections([.reminder])
		snapshot.appendItems(ekReminders)
		diffDatasource.apply(snapshot, animatingDifferences: true)
	}
	
	func updateReminderData(reminders: [EKReminder]) {
		let threeMonths = -90
		var rA = reminders
		
		rA.removeAll(where: { (reminder) -> Bool in
			return reminder.creationDate! < Calendar.current.forSpecifiedDay(value: threeMonths)
		})
		
		ekReminders = rA.sorted(by: { (reminderA, reminderB) -> Bool in
			return reminderA.creationDate! > reminderB.creationDate!
		})
	}
	

	
	// A check for the priority limit. Do not allow the user to carry over another task with the same priority type if it has exceeded the daily limit. They can however change their daily limit to allow for it
	// returns Tuple. The String in the tuple is the priority type in letters
	func checkPriority(persistentContainer: PersistentContainer?, reminder: EKReminder?, completionHandler: ((PriorityLimitThreshold, String)) -> ()) -> Void {
		var (threshold, message): (PriorityLimitThreshold, String) = (.WithinLimit, "None")
		
		guard let _pc = persistentContainer else {
			completionHandler((.Exceeded, "Persistent Container Error"))
			return
		}
		
		guard let reminder = reminder else {
			completionHandler((.Exceeded, "Priority Error"))
			return
		}
		
		let today: Date = Calendar.current.today()
		let todayDayObj: Day = _pc.fetchDayEntity(forDate: today) as! Day
		let p = convertApplePriorityToShortlist(applePriority: reminder.priority)
		let totalTasks = totalTasksForPriority(todayDayObj, priorityLevel: Int(p))
		
		if let p = Priority.init(rawValue: p) {
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
	
	// needs to be unified into one function // duplicate code
	func convertApplePriorityToShortlist(applePriority: Int) -> Int16 {
		switch applePriority {
			case 0: // low/none
				return Priority.low.rawValue
			case 5:
				return Priority.medium.rawValue
			case 1:
				return Priority.high.rawValue
			case 9:
				return Priority.low.rawValue
			default:
				return Priority.low.rawValue
		}
	}
	
	func totalTasksForPriority(_ day: Day, priorityLevel: Int) -> Int {
		guard let set = day.sortTasks() else {
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
	
	func doesTaskExist(for day: Day, in tableView: UITableView, at indexPath: IndexPath) throws {
		let ekReminder = reminderFor(row: indexPath.row)
		tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
		
		if let tasks = day.dayToTask as? Set<Task> {
			for task in tasks {
				if let reminderId = task.reminderId {
					if (reminderId == ekReminder.calendarItemIdentifier) {
						tableView.deselectRow(at: indexPath, animated: true)
						if (maxQuoteIndex % ReminderError.allCases.count == 0) {
							maxQuoteIndex = 0
						}
						
						// postfix increment
						defer {
							maxQuoteIndex = maxQuoteIndex + 1
						}
						throw ReminderError.allCases[maxQuoteIndex]
					}
				}

			}
		}
	}
}
