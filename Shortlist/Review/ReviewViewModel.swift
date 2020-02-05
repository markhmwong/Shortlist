//
//  ReviewViewModel.swift
//  Five
//
//  Created by Mark Wong on 26/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import StoreKit

class ReviewViewModel {
    
	typealias PriorityType = Int
	
	private var priorityCount: [PriorityType : Int] = [:]
	
	private var todaysPriorityCount: [PriorityType : Int] = [:]
	
    var tipProducts: [SKProduct]? {
        didSet {
            self.tipProducts?.sort(by: { (a, b) -> Bool in
                return Unicode.CanonicalCombiningClass(rawValue: UInt8(truncating: a.price)) < Unicode.CanonicalCombiningClass(rawValue: UInt8(truncating: b.price))
            })
        }
    }
	
    var buttonArr: [StandardButton] = []
	
    let reviewCellId = "reviewCellId"
    
	//yesterday's day object
    var dayEntity: Day? = nil {
        didSet {
            
            guard let dayToTask = dayEntity?.dayToTask else {
                taskDataSource = []
                return
            }
            
            taskDataSource = dayToTask.allObjects as! [Task]
        }
    }
    
    var taskDataSource: [Task] = [] {
        didSet {
            taskDataSource.sort { (a, b) -> Bool in
                return a.id < b.id
            }
        }
    }
    
    let taskSize: Int = 5
    
    var incompleteTasks: Int {
        var count = 0
        for task in taskDataSource {
            if (task.complete) {
                count += 1
            }
        }
        return count
    }
    
    var targetDate: Date = Calendar.current.yesterday()
    
    let cellHeight: CGFloat = 70.0
	
	var accolade: String = ""

	var carryOverTaskObjectsArr: [PriorityType: Task] = [:]
	
	func tableCellFor(tableView: UITableView, indexPath: IndexPath) -> ReviewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reviewCellId, for: indexPath) as! ReviewCell
		cell.backgroundColor = .clear
		guard cell.task != nil else {
			cell.task = nil
            return cell
        }
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
		let key: Int = Int(task.priority)
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
		
		print(priorityCount)
		print(todaysPriorityCount)
	}
	
	
	
	func checkPrioriy(persistentContainer: PersistentContainer?, task: Task?) {
		guard let _pc = persistentContainer else { return }
		guard let _task = task else { return }
		let today: Date = Calendar.current.today()
		let todayDayObj: Day = _pc.fetchDayEntity(forDate: today) as! Day
		
		if let priority = Priority.init(rawValue: _task.priority) {
			switch priority {
				case Priority.high:
					if (todaysPriorityCount[Int(_task.priority)] ?? 0 >= todayDayObj.highPriorityLimit) {
						
					}
				case Priority.medium:
					if (todaysPriorityCount[Int(_task.priority)] ?? 0 >= todayDayObj.mediumPriorityLimit) {
						
					}
				case Priority.low:
					if (todaysPriorityCount[Int(_task.priority)] ?? 0 >= todayDayObj.lowPriorityLimit) {
						
					}
				default:
					()
			}
		}
		

		
		
//		todayDayObj.highPriorityLimit
		
	}
}
