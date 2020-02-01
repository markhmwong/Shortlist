//
//  SettingsViewModel.swift
//  Five
//
//  Created by Mark Wong on 5/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class SettingsViewModel {
	
	enum Sections: Int, CaseIterable {
		case General = 0
		case About
		case Support
		case Data
	}
	
	enum General: Int, CaseIterable {
		case Review = 0
		case PriorityLimit
		case Stats
		case Notifications
		case NotificationsDisclaimer
	}
	
	enum Support: Int, CaseIterable {
		case ReviewApp = 0
		case Contact
	}
	
	enum Data: Int, CaseIterable {
		case DeleteAllData = 0
		case DeleteCategoryData
		case DeleteDisclaimer
	}
	
	enum About: Int, CaseIterable {
		case Info = 0
	}

	
	let sectionTitles = [
		"GENERAL",
		"ABOUT",
		"SUPPORT",
		"DATA",
	]
	
	// dict
	let generalTitles: [General : String] = [
		General.Review : "Review",
		General.PriorityLimit :"Priority Limit",
		General.Stats : "Stats",
		General.Notifications : "All Day Notifications", // all day notifications, standard notifications
		General.NotificationsDisclaimer : "A repeating hourly reminder for the entire day. Useful if you have a list of tasks that require your frequent attention. Every reminder begins on the hour i.e. 1pm, 2pm, 3pm, 4pm and so on. Reminders won't set within 2 hours before the next day."
	]
	
	let aboutTitles = [
		"Info"
	]
	
	let supportTitles = [
		"Review App (fix link)",
		"Contact / Feedback",
	]
	
	let dataTitles: [Data : String] = [
		Data.DeleteAllData : "Clear All Data",
		Data.DeleteCategoryData : "Clear Categories",
		Data.DeleteDisclaimer : "All data will be wiped on the device and will not be recoverable. Keep in mind this data will not be recoerable through this app again."
	]
    
    // Device parameters
    let appName = AppMetaData.name
    let appVersion = AppMetaData.version
    let deviceType = UIDevice().type
    let systemVersion = UIDevice.current.systemVersion

    // Email parameters
    let emailToRecipient = "hello@whizbangapps.xyz"
    let emailSubject = "Shortlist App Feedback"
    func emailBody() -> String {
        return """
        </br>
        </br>\(appName): \(appVersion!)\n
        </br>iOS: \(systemVersion)
        </br>Device: \(deviceType.rawValue)
        """
    }
	
	func titleForSection(sectionNum: Int) -> String {
		return sectionTitles[sectionNum]
	}
	
	func sectionsCount() -> Int {
		return Sections.allCases.count
	}
	
	func rowsInSection(section: Int) -> Int {
		switch Sections.init(rawValue: section) {
			case .General:
				return General.allCases.count
			case .About:
				return About.allCases.count
			case .Support:
				return Support.allCases.count
			case .Data:
				return Data.allCases.count
			default:
				return 0
		}
	}
	
	func registerTableViewCell(_ tableView: UITableView) {
		tableView.register(SettingsToggleCell.self, forCellReuseIdentifier: SettingsCellFactory.shared().toggleCellId)
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: SettingsCellFactory.shared().chevronCellId)
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: SettingsCellFactory.shared().defaultCellId)
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: SettingsCellFactory.shared().disclaimerCellId)
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: SettingsCellFactory.shared().warningCellId)
		tableView.register(SettingsDetailedChevronCell.self, forCellReuseIdentifier: SettingsCellFactory.shared().detailedChevronCellId)
		tableView.register(SettingsStandardCell.self, forCellReuseIdentifier: SettingsCellFactory.shared().standardCellId)

	}
	
	func tableViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		if let _section = Sections.init(rawValue: indexPath.section) {
			switch _section {
				case .General:
					if let _general = General.init(rawValue: indexPath.row) {
						switch _general {
							case .PriorityLimit:
								let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .DetailedChevron) as! SettingsDetailedChevronCell
								let priorityLimitStr = "\(currentHighPriorityTaskLimit()), \(currentMediumPriorityTaskLimit()), \(currentLowPriorityTaskLimit())"
								cell.updateName(generalTitles[_general] ?? "Unknown")
								cell.updateIcon("SettingsPriority.png")
								cell.updateDetailsLabel(priorityLimitStr)
								return cell
							case .Stats:
								let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .SettingsStandardCell) as! SettingsStandardCell
								cell.updateName(generalTitles[_general] ?? "Unknown")
								cell.updateIcon("SettingsStats.png")
								return cell
							case .Review:
								let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .SettingsStandardCell) as! SettingsStandardCell
								cell.updateName(generalTitles[_general] ?? "Unknown")
								cell.updateIcon("SettingsReview.png")
								return cell
							case .Notifications:
								let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .Toggle) as! SettingsToggleCell
								cell.updateName(generalTitles[_general] ?? "Unknown")
								cell.updateIcon("SettingsNotification.png")
								return cell
							case .NotificationsDisclaimer:
								let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .Disclaimer)
								cell.textLabel?.text = generalTitles[_general]
								return cell
						}
					}
				case .About:
					if let _about = About.init(rawValue: indexPath.row) {
						switch _about {
							case .Info:
								let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .SettingsStandardCell) as! SettingsStandardCell
								cell.updateName(aboutTitles[indexPath.row])
								cell.updateIcon("SettingsInfo.png")
								return cell
						}
					}
				case .Support:
					if let _support = Support.init(rawValue: indexPath.row) {
						let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .SettingsStandardCell) as! SettingsStandardCell
						cell.updateName(supportTitles[indexPath.row])
						
						switch _support {
							case .ReviewApp:
								cell.updateIcon("SettingsReviewApp.png")
								return cell
							case .Contact:
								cell.updateIcon("SettingsContact.png")
								return cell
						}
					}
				case .Data:
					if let _data = Data.init(rawValue: indexPath.row) {
						switch _data {
							case .DeleteAllData:
								let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .DefaultCell)
								cell.textLabel?.text = dataTitles[_data]
								cell.textLabel?.textColor = .red
								return cell
							case .DeleteDisclaimer:
								let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .Disclaimer)
								cell.textLabel?.text = dataTitles[_data]
								return cell
							case .DeleteCategoryData:
								let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .Warning)
								cell.textLabel?.text = dataTitles[_data]
								cell.textLabel?.textColor = .red
								return cell
						}
					}
			}
		}
		
		let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .DefaultCell)
		cell.textLabel?.text = "Unknown Cell"
		cell.textLabel?.textColor = UIColor.red
		return cell
	}
	
	func didSelectRow(_ tableView: UITableView, indexPath: IndexPath, delegate: SettingsViewController, persistentContainer: PersistentContainer) {
		
		if let _section = Sections(rawValue: indexPath.section) {
			
			switch _section {
				case .General:
				
					if let _general = General(rawValue: indexPath.row) {
						switch _general {
							case .PriorityLimit:
								delegate.coordinator?.showTaskLimit(persistentContainer)
							case .Stats:
								delegate.coordinator?.showStats(persistentContainer)
							case .Review:
								delegate.dismissAndShowReview()
							case .Notifications:
								// all day notifications
								// key chain
								// toggle cell
								// to do
								()
							case .NotificationsDisclaimer:
								()
						}
					}
				
				case .Support:
					if let _support = Support(rawValue: indexPath.row) {
						switch _support {
							case .Contact:
								delegate.emailFeedback()
							case .ReviewApp:
								delegate.writeReview()
						}
				}
				
				case .About:
				
					if let _about = About(rawValue: indexPath.row) {
						switch _about {
							case .Info:
								delegate.coordinator?.showAbout(persistentContainer)
						}
				}
				case .Data:
					if let _data = Data(rawValue: indexPath.row) {
						switch _data {
							case .DeleteAllData:
								delegate.confirmDeleteAllData()
							case .DeleteDisclaimer:
								// do nothing. text only
								()
							case .DeleteCategoryData:
								delegate.confirmDeleteCategoryData()
						}
					}
			}
			
		}
	}
	
	func headerForSection(section: Int) -> UITableViewHeaderFooterView? {
		let headerView = UITableViewHeaderFooterView()
		
		if #available(iOS 10, *) {
			headerView.contentView.backgroundColor = Theme.Cell.background
		} else {
			headerView.backgroundView?.backgroundColor = Theme.Cell.background
		}
		
		let size: CGFloat = Theme.Font.FontSize.Standard(.b5).value
		headerView.textLabel?.font = UIFont(name: Theme.Font.Regular, size: size)
		return headerView
	}
	
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
}

