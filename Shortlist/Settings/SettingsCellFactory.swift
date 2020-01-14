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
				let cell = tableView.dequeueReusableCell(withIdentifier: standardCellId, for: indexPath) as! SettingsStandardCell
				return cell
			case .Chevron:
				let cell = tableView.dequeueReusableCell(withIdentifier: standardCellId, for: indexPath) as! SettingsStandardCell
//				cell.backgroundColor = .clear
//				cell.textLabel?.textColor = .white
//
//				// chevron image set up
//				let image = UIImage(named: "ChevronRight.png")?.withRenderingMode(.alwaysTemplate)
//				let chevron = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.height * 0.5, height: cell.frame.height * 0.5))
//				chevron.image = image
//				cell.accessoryView = chevron
//				cell.tintColor = UIColor.white
				return cell
			case .DetailedChevron:
				let cell = tableView.dequeueReusableCell(withIdentifier: detailedChevronCellId, for: indexPath) as! SettingsDetailedChevronCell
				return cell
			case .Toggle:
				let cell = tableView.dequeueReusableCell(withIdentifier: toggleCellId, for: indexPath)
				cell.backgroundColor = UIColor.clear
				cell.textLabel?.textColor = .white
				return cell
			case .Disclaimer:
				let cell = tableView.dequeueReusableCell(withIdentifier: disclaimerCellId, for: indexPath)
				cell.backgroundColor = UIColor.clear
				cell.textLabel?.textColor = Theme.Font.FadedColor
				cell.textLabel?.numberOfLines = 0
				cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
				cell.textLabel?.font = UIFont(name: Theme.Font.Bold, size: Theme.Font.StandardSizes.b3.rawValue)
				cell.isUserInteractionEnabled = false
				return cell
			case .Warning:
				let cell = tableView.dequeueReusableCell(withIdentifier: warningCellId, for: indexPath)
				cell.backgroundColor = UIColor.clear
				cell.textLabel?.textColor = .red
				return cell
			case .DefaultCell:
				let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellId, for: indexPath)
				cell.backgroundColor = UIColor.clear
				cell.textLabel?.textColor = .white
				return cell
		}
	}
}
