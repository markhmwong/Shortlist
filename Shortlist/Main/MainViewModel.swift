//
//  MainViewModel.swift
//  Five
//
//  Created by Mark Wong on 16/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData
import EventKit

final class RunFireBaseOnce {
	private var hasRun: Bool = false
	
	typealias ActionClosure = () -> ()
	
	func run(action: ActionClosure) {
		guard hasRun == false else { return }
		
		action()
		hasRun = true
	}
}

class MainViewModel {
    
	// MARK: - ENUMS Priority and Cell
	enum CellType {
		case Regular
		case Available
	}
	
	enum SectionType: Int, CaseIterable {
		case HighPriority // Pressing
		case MediumPriority // Doable
		case LowPriority // Touch and Go
	}
	
	var runReviewOnce: RunFireBaseOnce = RunFireBaseOnce()
	
	// MARK: - Class variables
	var keyboardSize: CGRect = .zero
	
    let taskListCellId = "taskCellId"
    
    weak var dayEntity: Day? = nil
    
    let taskSizeLimit: Int = 100
    
    let cellHeight: CGFloat = 70.0
	
	var globalTaskAmount: Int = 0
	
	// task inputs
	var category: String? = ""
	var taskName: String = "An interesting task.."
	var priority: Priority = .high
	
	typealias SectionNumber = Int16 // This is based on the attribute property 'priority'
	
	var sortedSet: [Task]? = nil
	
	//used only for preplanned view controller
	let tomorrow = Calendar.current.forSpecifiedDay(value: 1)
	
	private var randomTip: String = ""
	
	private var connectivity: Connectivity? = Connectivity()
	
	private var reminderService: ReminderService = ReminderService()
	
	// MARK: - Helper Methods
	func taskForRow(indexPath: IndexPath) -> Task? {
		return sortedSet?[indexPath.row]
	}
	
	// tasks are sorted by priority then by date
	func sortTasks(_ day: Day) -> [Task]? {
		return day.sortTasks()
	}
	
	func totalTasksForPriority(_ day: Day, priorityLevel: Int) -> Int {
		guard let set = sortTasks(day) else {
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
	
	func numberOfSections() -> Int {
		return SectionType.allCases.count
	}
	
	func getRandomTip() -> String {
		randomTip = TipsService.shared.randomTip()
		return randomTip
	}
	
	func checkPriorityLimit(persistentContainer: PersistentContainer, priorityLevel: Int, delegate: MainViewControllerProtocol) -> Bool {
		
		guard let dayEntity = dayEntity else {
			delegate.showAlert("Internal Error with Day Model")
			return false
		}

		
		let totalTasks = totalTasksForPriority(dayEntity, priorityLevel: priorityLevel)
		
		if let p = Priority.init(rawValue: Int16(priorityLevel)) {
			switch p {
				case Priority.high:
					if (totalTasks >= KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.HighPriorityLimit) ?? totalTasks) {
						// warning
						delegate.showAlert("High Priority Limit Reached")
						return false
					}
				case Priority.medium:
					if (totalTasks >= KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.MediumPriorityLimit) ?? totalTasks) {
						delegate.showAlert("Medium Priority Limit Reached")
						return false
					}
				case Priority.low:
					if (totalTasks >= KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.LowPriorityLimit) ?? totalTasks) {
						// warning
						delegate.showAlert("Low Priority Limit Reached")
						return false
					}
				case Priority.none:
				()
			}
			return true
		}
		return true
	}

	// MARK: - TableView Methods
	func registerCell(_ tableView: UITableView) {
        tableView.register(TaskCell.self, forCellReuseIdentifier: taskListCellId)
	}
	
	// MARK: - Cell Layout
//	func tableViewCell(_ tableView: UITableView, indexPath: IndexPath, fetchedResultsController: NSFetchedResultsController<Day>?, persistentContainer: PersistentContainer?) -> TaskCell {
//
//		let cell = tableView.dequeueReusableCell(withIdentifier: taskListCellId, for: indexPath) as! TaskCell
//		cell.setupCellLayout()
//		cell.persistentContainer = persistentContainer
//		cell.task = taskForRow(indexPath: indexPath)
//
//        cell.updateDailyStats = { [weak self] (task) in
//			guard let _self = self else { return }
//			if (task.complete) {
//				_self.dayEntity?.dayToStats?.totalCompleted += 1
//            } else {
//				_self.dayEntity?.dayToStats?.totalCompleted -= 1
//            }
//
//        }
//
//		cell.updateStats = { (task) in
//			let stat = persistentContainer?.fetchStatEntity()
//
//            if (task.complete) {
//				// ADD TO STATS
//
//				// completed tasks stat
//				stat?.addToTotalCompleteTasks(numTasks: 1)
//				stat?.removeFromTotalIncompleteTasks(numTasks: 1)
//
//				// category specific stat
//				stat?.addToCategoryACompleteTask(category: task.category)
//
//				//priority task
//				if let priority: Priority = Priority(rawValue: task.priority) {
//					stat?.addToPriority(numTasks: 1, priority: priority)
//				}
//            } else {
//				// REMOVE FROM STATS
//
//				// completed tasks stat
//				stat?.addToTotalIncompleteTasks(numTasks: 1)
//				stat?.removeFromTotalCompleteTasks(numTasks: 1)
//
//				// category specific stat
//				stat?.removeFromCategoryACompleteTask(category: task.category)
//
//				//priority task
//				if let priority: Priority = Priority(rawValue: task.priority) {
//					stat?.removeFromPriority(numTasks: 1, priority: priority)
//				}
//            }
//		}
//
//		cell.updateBackLog = { (task) in
//			guard let _persistentContainer = persistentContainer else { return }
//			let category = task.category
//
//			if (task.complete) {
//				if (_persistentContainer.categoryExistsInBackLog(category)) {
//					if let backLog: BackLog = _persistentContainer.fetchBackLog(forCategory: category) {
//						let taskObj: Task = _persistentContainer.viewContext.object(with: task.objectID) as! Task
//						backLog.removeFromBackLogToTask(taskObj)
//					}
//				}
//			} else {
//				if (_persistentContainer.categoryExistsInBackLog(category)) {
//					if let backLog: BackLog = _persistentContainer.fetchBackLog(forCategory: category) {
//						let taskObj: Task = _persistentContainer.viewContext.object(with: task.objectID) as! Task
//						backLog.addToBackLogToTask(taskObj)
//					}
//				}
//			}
//		}
//
//        cell.updateWatch = { (tasks) in
//			self.syncWithWatchData(fetchedResultsController: fetchedResultsController)
//        }
//
//		cell.updateReminder = { (task) in
//			if let id = task.reminderId {
//				self.reminderService.fetchReminders { (reminders) in
//					guard let reminders = reminders else { return }
//					for reminder in reminders {
//						if (reminder.calendarItemIdentifier == id) {
//							reminder.isCompleted = task.complete
//							self.reminderService.commitChanges(reminder: reminder)
//						}
//					}
//				}
//			}
//		}
//		return cell
//	}
	
//	func headerForSection(_tableView: UITableView, section: Int) -> UIView {
//		let view = UITableViewHeaderFooterView()
//
//		if let sectionType = SectionType.init(rawValue: section) {
//			switch sectionType {
//				case .HighPriority:
//					view.tintColor = UIColor.orange.adjust(by: -30.0) ?? UIColor.orange
//					view.textLabel?.attributedText = NSMutableAttributedString(string: "Pressing", attributes: [NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b5).value)!, NSAttributedString.Key.foregroundColor: UIColor.orange.adjust(by: 20.0) ?? Theme.Font.DefaultColor])
//				case .MediumPriority:
//					view.tintColor = UIColor.purple.adjust(by: -20.0) ?? UIColor.purple
//					view.textLabel?.attributedText = NSMutableAttributedString(string: "Doable", attributes: [NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b5).value)!, NSAttributedString.Key.foregroundColor: UIColor.purple.adjust(by: 20.0) ?? Theme.Font.DefaultColor])
//				case .LowPriority:
//					view.tintColor = UIColor.blue.adjust(by: -20.0) ?? UIColor.blue
//					view.textLabel?.attributedText = NSMutableAttributedString(string: "Touch and go", attributes: [NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b5).value)!, NSAttributedString.Key.foregroundColor: UIColor.blue.adjust(by: 60.0) ?? Theme.Font.DefaultColor])
//			}
//		}
//		return view
//	}
	
	// MARK: - Collection View Methods
	func createCompositionalLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			
			// item
			let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalHeight(1.0))

			let item = NSCollectionLayoutItem(layoutSize: itemSize)
			
			// group
			let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
			
			let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
			
			let section = NSCollectionLayoutSection(group: group)
			section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
			
			return section
		}
		return layout
	}
	

	
	// MARK: - Apple Watch
	func syncWithWatchData(fetchedResultsController: NSFetchedResultsController<Day>?) {
		let taskList = fetchedResultsController?.fetchedObjects?.first?.dayToTask as! Set<Task>
		var taskStruct: [TaskStruct] = []
		for task in taskList {
			taskStruct.append(TaskStruct(date: task.createdAt! as Date,name: task.name!, complete: task.complete, priority: task.priority, category: task.category, reminder: task.reminder! as Date, reminderState: task.reminderState, details: task.details ?? ""))
		}
		do {
			let data = try JSONEncoder().encode(taskStruct)
			WatchSessionHandler.shared.updateApplicationContext(with: ReceiveApplicationContextKey.UpdateTaskListFromPhone.rawValue, data: data)
		} catch (_) {
			//
		}
	}
}
