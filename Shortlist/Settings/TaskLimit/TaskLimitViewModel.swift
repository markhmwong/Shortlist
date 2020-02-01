//
//  TaskListViewModel.swift
//  Five
//
//  Created by Mark Wong on 5/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class TaskLimitViewModel {
	
	enum PriorityLevel: Int, CaseIterable {
		case HighPriority = 0
		case MediumPriority
		case LowPriority
	}
	
	let sections: Int = 3
		
	typealias TaskLimit = Int

	var priorityLimits: [PriorityLevel : TaskLimit] = [
		PriorityLevel.HighPriority : 1,
		PriorityLevel.MediumPriority : 5,
		PriorityLevel.LowPriority : 5,
	]
	
	//persistentContainer?
	init(_ persistentcontainer: PersistentContainer?) {
		
		// load priority levels from keychain
		
	}

	let defaultRows = 1
    
    let cellId = "TaskLimitCellId"

	func taskLimitFor(section: Int) -> Int {
		if let section = PriorityLevel.init(rawValue: section) {
			switch section {
				case .HighPriority:
					return currentHighPriorityTaskLimit()
				case .MediumPriority:
					return currentMediumPriorityTaskLimit()
				case .LowPriority:
					return currentLowPriorityTaskLimit()
			}
		}
		return 1
	}
	
	func numSections() -> Int {
		return PriorityLevel.allCases.count
	}
	
	func rowsFor(section: Int) -> Int {
		if let key = PriorityLevel.init(rawValue: section) {
			return priorityLimits[key] ?? defaultRows
		}
		return defaultRows
	}
	
	func headerForSection(section: Int) -> UIView? {
		let view = UITableViewHeaderFooterView()
		let backgroundView = UIView()
		backgroundView.backgroundColor = UIColor.clear
		view.backgroundView = backgroundView

		if let section = PriorityLevel.init(rawValue: section) {
			switch section {
				case .HighPriority:
					view.textLabel?.text = "High"
				case .MediumPriority:
					view.textLabel?.text = "Medium"
				case .LowPriority:
					view.textLabel?.text = "Low"
			}
		}

		view.textLabel?.textColor = UIColor.white
		return view
	}
	
	// section gradient turned off for now
//	func updateGradient(layer: CAGradientLayer, color: UIColor) {
//		layer.colors = [color.adjust(by: -45.0)!.cgColor, color.adjust(by: 0.0)!.cgColor]
//	}

    func currentHighPriorityTaskLimit() -> Int {
        if let taskLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.HighPriorityLimit) {
            return taskLimit
        }
        return 3
    }
	
    func currentMediumPriorityTaskLimit() -> Int {
        if let taskLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.MediumPriorityLimit) {
            return taskLimit
        }
        return 3
    }
	
    func currentLowPriorityTaskLimit() -> Int {
        if let taskLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.LowPriorityLimit) {
            return taskLimit
        }
        return 3
    }
	
	func tableViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .clear
		cell.accessoryType = .none
		let row = indexPath.row + 1
		cell.accessoryType = cellCheckmark(section: indexPath.section, row: row)

        cell.textLabel?.text = "\(row)"
        cell.textLabel?.textColor = UIColor.white
        return cell
	}
	
	func cellCheckmark(section: Int, row: Int) -> UITableViewCell.AccessoryType {
		switch section {
			case 0:
				if (currentHighPriorityTaskLimit() == row) {
					return .checkmark
				}
			case 1:
				if (currentMediumPriorityTaskLimit() == row) {
					return .checkmark
				}
			case 2:
				if (currentLowPriorityTaskLimit() == row) {
					return .checkmark
				}
			default:
				return .none
		}
		return .none
	}
	
	func updateDayObject(persistentContainer: PersistentContainer) {
		let today = persistentContainer.fetchDayEntity(forDate: Calendar.current.today()) as! Day
		today.highPriorityLimit = Int16(currentHighPriorityTaskLimit())
		today.lowPriorityLimit = Int16(currentLowPriorityTaskLimit())
		today.mediumPriorityLimit = Int16(currentMediumPriorityTaskLimit())
	}
	
	func updateKeychain(indexPath: IndexPath) {
		let row = indexPath.row + 1
		switch indexPath.section {
			case 0:
				KeychainWrapper.standard.set(row, forKey: SettingsKeyChainKeys.HighPriorityLimit)
			case 1:
				KeychainWrapper.standard.set(row, forKey: SettingsKeyChainKeys.MediumPriorityLimit)
			case 2:
				KeychainWrapper.standard.set(row, forKey: SettingsKeyChainKeys.LowPriorityLimit)
			default:
				()
		}
	}
}
