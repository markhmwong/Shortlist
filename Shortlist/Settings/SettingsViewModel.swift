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
		case GlobalTask
		case GlobalTaskDisclaimer
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
	
	// general items
	let generalTitles: [General : String] = [
		General.Review : "Review",
		General.PriorityLimit :"Priority Limiter",
		General.Stats : "Stats",
		General.Notifications : "All Day Notifications", // all day notifications, standard notifications
		General.NotificationsDisclaimer : "A repeating hourly reminder for the entire day. Useful if you have a list of tasks that require your frequent attention. Every reminder begins on the hour i.e. 1pm, 2pm, 3pm, 4pm and so on. Reminders won't set within 2 hours before the next day.",
		General.GlobalTask : "Global Task Tally",
		General.GlobalTaskDisclaimer : "Toggle to participate in accumulating completed tasks with other users of Shortlist around the world to see how far we can reach to the end of 2020. No other data is sent other than the tasks completed for the day.",
	]
	
	let aboutTitles = [
		"Info"
	]
	
	let supportTitles = [
		"Review App",
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
		tableView.register(SettingsDisclaimerCell.self, forCellReuseIdentifier: SettingsCellFactory.shared().disclaimerCellId)
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: SettingsCellFactory.shared().warningCellId)
		tableView.register(SettingsDetailedChevronCell.self, forCellReuseIdentifier: SettingsCellFactory.shared().detailedChevronCellId)
		tableView.register(SettingsStandardCell.self, forCellReuseIdentifier: SettingsCellFactory.shared().standardCellId)

	}
	
	func cellForTableView(_ tableView: UITableView, indexPath: IndexPath, delegate: SettingsViewController) -> UITableViewCell {
		if let _section = Sections.init(rawValue: indexPath.section) {
			switch _section {
				case .General:
					if let _general = General.init(rawValue: indexPath.row) {
						switch _general {
							case .PriorityLimit:
								let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .DetailedChevron) as! SettingsDetailedChevronCell
								cell.updateName(generalTitles[_general] ?? "Unknown")
								cell.updateIcon("exclamationmark.circle.fill")
								cell.updateDetailsLabel(highPriorityLimit: "\(currentHighPriorityTaskLimit())", mediumPriorityLimit: "\(currentMediumPriorityTaskLimit())", lowPriorityLimit: "\(currentLowPriorityTaskLimit())")
								return cell
							case .Stats:
								let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .SettingsStandardCell) as! SettingsStandardCell
								cell.updateName(generalTitles[_general] ?? "Unknown")
								cell.updateIcon("waveform.path.ecg")
								return cell
							case .Review:
								let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .SettingsStandardCell) as! SettingsStandardCell
								cell.updateName(generalTitles[_general] ?? "Unknown")
								cell.updateIcon("magnifyingglass")
								return cell
							case .Notifications:
								let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .Toggle) as! SettingsToggleCell
								cell.updateName(generalTitles[_general] ?? "Unknown")
								cell.updateIcon("sunrise.fill")
								cell.updateToggle(KeychainWrapper.standard.bool(forKey: SettingsKeyChainKeys.AllDayNotifications) ?? false)
								cell.toggleFunction = { (toggleSwitch) in
									let hoursRemaining = Date().hoursRemaining()
									
									KeychainWrapper.standard.set(toggleSwitch.isOn, forKey: SettingsKeyChainKeys.AllDayNotifications)
									
									if (hoursRemaining < 2) {
										toggleSwitch.isOn = false
										KeychainWrapper.standard.set(false, forKey: SettingsKeyChainKeys.AllDayNotifications)
										cell.showWarning?()
									} else {
										// don't trigger if hoursRemiaining is less than 2. 2 hours remaining in the day means it's close to 10pm rendering the feature redundant.
										if (toggleSwitch.isOn) {
											for hour in 0..<hoursRemaining {
												let id = 24 - (hoursRemaining - hour)
												let timeToNextHour = Date().timeRemainingToHour()
												let timeRemaining = timeToNextHour + Double(60 * hour)
												LocalNotificationsService.shared.addAllDayNotification(id: "\(id)", notificationContent: [LocalNotificationKeys.Title : "Frequent Reminder"], timeRemaining: timeRemaining) // add content/body to notification
											}
										} else {
											// remove all notifications
											for hour in 0..<hoursRemaining {
												let id = 24 - (hoursRemaining - hour)
												LocalNotificationsService.shared.removeNotification(id: "\(id)")
											}
										}
									}
								}
								cell.showWarning = { () in
									delegate.coordinator?.showAlertBox("All day alerts are no longer allowed for the remainder of the night.")
								}
								return cell
							case .NotificationsDisclaimer:
								let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .Disclaimer) as! SettingsDisclaimerCell
								cell.updateLabel(string: generalTitles[_general] ?? "Unknown disclaimer")
								return cell
							case .GlobalTask:
								let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .Toggle) as! SettingsToggleCell
								cell.textLabel?.text = generalTitles[_general]
								cell.updateIcon("globe")
								cell.updateToggle(KeychainWrapper.standard.bool(forKey: SettingsKeyChainKeys.GlobalTasks) ?? false)
								cell.toggleFunction = { (toggleSwitch) in
									KeychainWrapper.standard.set(toggleSwitch.isOn, forKey: SettingsKeyChainKeys.GlobalTasks)
								}
								return cell
							case .GlobalTaskDisclaimer:
								let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .Disclaimer) as! SettingsDisclaimerCell
								cell.updateLabel(string: generalTitles[_general] ?? "Unknown disclaimer")
								return cell
						}
					}
				case .About:
					if let _about = About.init(rawValue: indexPath.row) {
						switch _about {
							case .Info:
								let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .SettingsStandardCell) as! SettingsStandardCell
								cell.updateName(aboutTitles[indexPath.row])
								cell.updateIcon("info.circle.fill")
								return cell
						}
					}
				case .Support:
					if let _support = Support.init(rawValue: indexPath.row) {
						let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .SettingsStandardCell) as! SettingsStandardCell
						cell.updateName(supportTitles[indexPath.row])
						switch _support {
							case .ReviewApp:
								cell.updateIcon("text.bubble.fill")
								return cell
							case .Contact:
								cell.updateIcon("envelope.fill")
								return cell
						}
					}
				case .Data:
					if let _data = Data.init(rawValue: indexPath.row) {
						switch _data {
							case .DeleteAllData:
								let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .Warning)
								cell.textLabel?.text = dataTitles[_data]
								cell.textLabel?.textColor = .red
								return cell
							case .DeleteDisclaimer:
								let cell = SettingsCellFactory.shared().cellType(tableView: tableView, indexPath: indexPath, cellType: .Disclaimer) as! SettingsDisclaimerCell
								cell.updateLabel(string: dataTitles[_data] ?? "Unknown disclaimer")
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
								()
//								delegate.coordinator?.showTaskLimit(persistentContainer)
							case .Stats:
								delegate.coordinator?.showStats(persistentContainer)
							case .Review:
								delegate.dismissAndShowReview()
							case .Notifications, .NotificationsDisclaimer, .GlobalTaskDisclaimer, .GlobalTask:
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
	
	func viewForHeader(section: Int) -> UIView? {
		let view = UITableViewHeaderFooterView()
		view.backgroundView?.backgroundColor = .orange
		view.textLabel?.textColor = UIColor.white.withAlphaComponent(0.7)
		return view
	}
	
	func willDisplayHeader(view: UIView, section: Int) {
		let headerView = view as! UITableViewHeaderFooterView
		
		if #available(iOS 10, *) {
			headerView.contentView.backgroundColor = Theme.Cell.background
		} else {
			headerView.backgroundView?.backgroundColor = Theme.Cell.background
		}
		
		let size: CGFloat = Theme.Font.FontSize.Standard(.b5).value
		headerView.textLabel?.font = UIFont(name: Theme.Font.Regular, size: size)
		headerView.textLabel?.textColor = Theme.Font.DefaultColor
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

