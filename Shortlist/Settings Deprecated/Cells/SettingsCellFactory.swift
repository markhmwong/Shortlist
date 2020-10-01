//
//  SettingsCellFactory.swift
//  Shortlist
//
//  Created by Mark Wong on 14/11/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

enum SettingsCellType: Int {
	case Chevron = 0
	case SettingsStandardCell
	case DetailedChevron
	case Toggle
	case Disclaimer
	case DefaultCell
	case Warning
}

class SettingsCellFactory {
	
	private static var sharedFactory = SettingsCellFactory()
	
	let chevronCellId = "ChevronCellId"
	
	let toggleCellId = "ToggleCellId"
	
	let defaultCellId = "DefaultCellId"
	
	let disclaimerCellId = "DisclaimerCellId"
	
	let warningCellId = "WarningCellId"
	
	let standardCellId = "StandardCellId"

	let detailedChevronCellId = "DetailedChevronCellId"
	
	class func shared() -> SettingsCellFactory {
		return sharedFactory
	}
	
	func cellType(tableView: UITableView, indexPath: IndexPath, cellType: SettingsCellType) -> UITableViewCell {
		switch cellType {
			case .SettingsStandardCell:
				let cell = SettingsStandardCell.init(style: .default, reuseIdentifier: standardCellId)	
				return cell
			case .Chevron:
				let cell = tableView.dequeueReusableCell(withIdentifier: standardCellId, for: indexPath) as! SettingsStandardCell
				return cell
			case .DetailedChevron:
				let cell = SettingsDetailedChevronCell.init(style: .value1, reuseIdentifier: detailedChevronCellId)
				return cell
			case .Toggle:
				let cell = tableView.dequeueReusableCell(withIdentifier: toggleCellId, for: indexPath) as! SettingsToggleCell
				cell.textLabel?.textColor = Theme.Font.DefaultColor
				return cell
			case .Disclaimer:
				let cell = tableView.dequeueReusableCell(withIdentifier: disclaimerCellId, for: indexPath) as! SettingsDisclaimerCell
				cell.isUserInteractionEnabled = false
				return cell
			case .Warning:
				let cell = tableView.dequeueReusableCell(withIdentifier: warningCellId, for: indexPath)
				cell.backgroundColor = Theme.GeneralView.background
				cell.textLabel?.textColor = Theme.Font.Warning
				return cell
			case .DefaultCell:
				let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellId, for: indexPath)
				cell.textLabel?.textColor = Theme.Font.DefaultColor
				return cell
		}
	}
}
