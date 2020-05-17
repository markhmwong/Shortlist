//
//  ReviewViewModel.swift
//  Five
//
//  Created by Mark Wong on 26/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import StoreKit

enum PriorityLimitThreshold {
	case Exceeded
	case WithinLimit
}

class ReviewViewModel {
    
	let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b3).value)!]
	
	typealias PriorityCount = Int
	
	private var priorityCount: [PriorityCount : Int] = [:]
	
	private var todaysPriorityCount: [PriorityCount : Int] = [:]
	
    var tipProducts: [SKProduct]? {
        didSet {
            self.tipProducts?.sort(by: { (a, b) -> Bool in
                return Unicode.CanonicalCombiningClass(rawValue: UInt8(truncating: a.price)) < Unicode.CanonicalCombiningClass(rawValue: UInt8(truncating: b.price))
            })
        }
    }
	
    var buttonArr: [StandardButton] = []
	
    private let reviewCellId = "reviewCellId"
    
	// set's up the dataSource when yesterday's day object is set
    var dayEntity: Day? = nil {
        didSet {
            
            guard let dayToTask = dayEntity?.dayToTask else {
                reviewTaskSet = []
                return
            }
            
			reviewTaskSet = sortTasks(dayToTask as? Set<Task>)
		}
    }
    
    var reviewTaskSet: [Task]? = []
    
    private let taskSize: Int = 5
    
    var incompleteTasks: Int {
        var count = 0
		guard let _taskDataSource = reviewTaskSet else {
			return count
		}
        for task in _taskDataSource {
            if (task.complete) {
                count += 1
            }
        }
        return count
    }
    
    var targetDate: Date = Calendar.current.yesterday()
    
    let cellHeight: CGFloat = 70.0
	
	var accolade: String = ""

	typealias PriorityType = String
	
	var carryOverTaskObjectsArr: [PriorityType: Task] = [:]
	
	// tasks are sorted by priority then by date
	func sortTasks(_ tasks: Set<Task>?) -> [Task]? {
		guard let set = tasks else {
			return []
		}
		if (!set.isEmpty) {
            return set.sorted(by: { (taskA, taskB) -> Bool in
				// sort same priority by date
				if (taskA.priority == taskB.priority) {
					return ((taskA.createdAt! as Date).compare(taskB.createdAt! as Date) == .orderedAscending)
				} else {
					// otherwise order by priority
					return taskA.priority < taskB.priority
				}
            })
		} else {
			return []
		}
	}
	
	func taskForRow(indexPath: IndexPath) -> Task? {
		return reviewTaskSet?[indexPath.row] ?? nil
	}
	
	func tableViewCellFor(tableView: UITableView, indexPath: IndexPath) -> ReviewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reviewCellId, for: indexPath) as! ReviewCell
		cell.backgroundColor = .clear
		cell.task = taskForRow(indexPath: indexPath)
		return cell
	}
	
	func registerCells(tableView: UITableView) {
        tableView.register(ReviewCell.self, forCellReuseIdentifier: reviewCellId)
	}
	
	func tableCellAt(tableView: UITableView, indexPath: IndexPath) -> ReviewCell {
		let cell = tableView.cellForRow(at: indexPath) as! ReviewCell
		guard cell.task != nil else {
			cell.task = nil
            return cell
        }
		return cell
	}
	
	func handleCarryOver(task: Task, cell: ReviewCell) {
		let key: String = task.objectID.uriRepresentation().relativeString

		if cell.selectedState {
			carryOverTaskObjectsArr[key] = task
		} else {
			carryOverTaskObjectsArr.removeValue(forKey: key)
		}
	}
	
	func resolveAccolade() -> String {
		guard let _dayEntity = dayEntity else { return "Unknown Accolade" }
		let dailyAccolade = DailyAccolades(day: _dayEntity)
		return dailyAccolade.evaluateFinalAward()
	}
	
	func resolvePriorityCount(persistentContainer: PersistentContainer) {
		guard let _dayEntity = dayEntity else { return }
		let today: Date = Calendar.current.today()
		let todayDayObj: Day = persistentContainer.fetchDayEntity(forDate: today) as! Day
		
		let tasks = _dayEntity.dayToTask as! Set<Task>
		let todayTasks = todayDayObj.dayToTask as! Set<Task>
		
		for task in tasks {
			priorityCount[Int(task.priority)] = (priorityCount[Int(task.priority)] ?? 0) + 1
		}
		
		for task in todayTasks {
			todaysPriorityCount[Int(task.priority)] = (todaysPriorityCount[Int(task.priority)] ?? 0) + 1
		}
	}
	
	// A check for the priority limit. Do not allow the user to carry over another task with the same priority type if it has exceeded the daily limit. They can however change their daily limit to allow for it
	// returns Tuple. The String in the tuple is the priority type in letters
	func checkPriority(persistentContainer: PersistentContainer?, task: Task?, completionHandler: ((PriorityLimitThreshold, String)) -> ()) -> Void {
		var (threshold, message): (PriorityLimitThreshold, String) = (.WithinLimit, "None")
		
		guard let _pc = persistentContainer else {
			completionHandler((.Exceeded, "Persistent Container Error"))
			return
		}
		
		guard let _task = task else {
			completionHandler((.Exceeded, "Task Error"))
			return
		}
		
		let today: Date = Calendar.current.today()
		let todayDayObj: Day = _pc.fetchDayEntity(forDate: today) as! Day
		let totalTasks = totalTasksForPriority(todayDayObj, priorityLevel: Int(_task.priority))

		if let p = Priority.init(rawValue: _task.priority) {
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
	
	// In conjunction with the checkPriority() method
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
	
	func continueReminder() {
		let localEveningTime = Calendar.current.sevenDaysFromToday()
		print(localEveningTime)
//		LocalNotificationsService.shared.addReminderNotification(dateIdentifier: <#T##Date#>, notificationContent: <#T##[LocalNotificationKeys : String]#>, timeRemaining: <#T##Double#>)
	}
}
