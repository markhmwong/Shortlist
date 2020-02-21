//
//  MainViewModel.swift
//  Five
//
//  Created by Mark Wong on 16/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class MainViewModel {
    
	enum CellType {
		case Regular
		case Available
	}
	
	enum SectionType: Int, CaseIterable {
		case HighPriority // Pressing
		case MediumPriority // Doable
		case LowPriority // Touch and Go
	}
	
	var taskName: String = "An interesting task.."
	
	var keyboardSize: CGRect = .zero
	
    let taskListCellId = "taskCellId"
    
    weak var dayEntity: Day? = nil
    
    let taskSizeLimit: Int = 100
    
    let cellHeight: CGFloat = 70.0
	
	var category: String? = ""
	
	typealias SectionNumber = Int16 // This is based on the attribute property 'priority'
	
	var sortedSet: [Task]? = nil
	
	//used only for preplanned view controller
	let tomorrow = Calendar.current.forSpecifiedDay(value: 1)
	
	private var randomTip: String = ""
	
	func taskForRow(indexPath: IndexPath) -> Task? {
		return sortedSet?[indexPath.row]
	}
	
	// tasks are sorted by priority then by date
	func sortTasks(_ day: Day) -> [Task]? {
		let set = day.dayToTask as? Set<Task>
		if (!set!.isEmpty) {
            return set?.sorted(by: { (taskA, taskB) -> Bool in
				// sort same priority by date
				if (taskA.priority == taskB.priority) {
					return ((taskA.createdAt! as Date).compare(taskB.createdAt! as Date) == .orderedAscending)
				} else {
					// otherwise order by priority
					return taskA.priority < taskB.priority
				}
            })
		} else {
			return nil
		}
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

	func registerCell(_ tableView: UITableView) {
        tableView.register(TaskCell.self, forCellReuseIdentifier: taskListCellId)
	}
	
	func tableViewCell(_ tableView: UITableView, indexPath: IndexPath, fetchedResultsController: NSFetchedResultsController<Day>?, persistentContainer: PersistentContainer?) -> TaskCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: taskListCellId, for: indexPath) as! TaskCell
		cell.setupCellLayout()
		cell.persistentContainer = persistentContainer
		cell.task = taskForRow(indexPath: indexPath)
		
        cell.updateDailyStats = { [weak self] (task) in
			guard let _self = self else { return }
			if (task.complete) {
				_self.dayEntity?.dayToStats?.totalCompleted += 1
            } else {
				_self.dayEntity?.dayToStats?.totalCompleted -= 1
            }

        }

		cell.updateStats = { (task) in
			let stat = persistentContainer?.fetchStatEntity()

            if (task.complete) {
				// ADD TO STATS
				
				// completed tasks stat
				stat?.addToTotalCompleteTasks(numTasks: 1)
				stat?.removeFromTotalIncompleteTasks(numTasks: 1)

				// category specific stat
				stat?.addToCategoryACompleteTask(category: task.category)
				
				//priority task
				if let priority: Priority = Priority(rawValue: task.priority) {
					stat?.addToPriority(numTasks: 1, priority: priority)
				}
            } else {
				// REMOVE FROM STATS
				
				// completed tasks stat
				stat?.addToTotalIncompleteTasks(numTasks: 1)
				stat?.removeFromTotalCompleteTasks(numTasks: 1)

				// category specific stat
				stat?.removeFromCategoryACompleteTask(category: task.category)
				
				//priority task
				if let priority: Priority = Priority(rawValue: task.priority) {
					stat?.removeFromPriority(numTasks: 1, priority: priority)
				}
            }
		}

		cell.updateBackLog = { (task) in
			guard let _persistentContainer = persistentContainer else { return }
			let category = task.category

			if (task.complete) {
				if (_persistentContainer.categoryExistsInBackLog(category)) {
					if let backLog: BackLog = _persistentContainer.fetchBackLog(forCategory: category) {
						let taskObj: Task = _persistentContainer.viewContext.object(with: task.objectID) as! Task
						backLog.removeFromBackLogToTask(taskObj)
					}
				}
			} else {
				if (_persistentContainer.categoryExistsInBackLog(category)) {
					if let backLog: BackLog = _persistentContainer.fetchBackLog(forCategory: category) {
						let taskObj: Task = _persistentContainer.viewContext.object(with: task.objectID) as! Task
						backLog.addToBackLogToTask(taskObj)
					}
				}
			}
		}

        cell.updateWatch = { (task) in
            //WCSession
            let taskList = fetchedResultsController?.fetchedObjects?.first?.dayToTask as! Set<Task>
            var tempTaskStruct: [TaskStruct] = []
            for task in taskList {
				tempTaskStruct.append(TaskStruct(date: task.createdAt as! Date,name: task.name!, complete: task.complete, priority: task.priority))
            }
            do {
                let data = try JSONEncoder().encode(tempTaskStruct)
                WatchSessionHandler.shared.updateApplicationContext(with: ReceiveApplicationContextKey.UpdateTaskListFromPhone.rawValue, data: data)
            } catch (let err) {
                print("\(err)")
            }
        }
        
		return cell
	}
	
	func headerForSection(_tableView: UITableView, section: Int) -> UIView {
		let view = UITableViewHeaderFooterView()
		
		if let sectionType = SectionType.init(rawValue: section) {
			switch sectionType {
				case .HighPriority:
					view.tintColor = UIColor.orange.adjust(by: -30.0) ?? UIColor.orange
					view.textLabel?.attributedText = NSMutableAttributedString(string: "Pressing", attributes: [NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b5).value)!, NSAttributedString.Key.foregroundColor: UIColor.orange.adjust(by: 20.0) ?? UIColor.white])
				case .MediumPriority:
					view.tintColor = UIColor.purple.adjust(by: -20.0) ?? UIColor.purple
					view.textLabel?.attributedText = NSMutableAttributedString(string: "Doable", attributes: [NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b5).value)!, NSAttributedString.Key.foregroundColor: UIColor.purple.adjust(by: 20.0) ?? UIColor.white])
				case .LowPriority:
					view.tintColor = UIColor.blue.adjust(by: -20.0) ?? UIColor.blue
					view.textLabel?.attributedText = NSMutableAttributedString(string: "Touch and go", attributes: [NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b5).value)!, NSAttributedString.Key.foregroundColor: UIColor.blue.adjust(by: 60.0) ?? UIColor.white])
			}
		}
		return view
	}
	
	func numberOfSections() -> Int {
		return SectionType.allCases.count
	}
	
	func getRandomTip() -> String {
		randomTip = TipsService.shared.randomTip()
		return randomTip
	}
}
