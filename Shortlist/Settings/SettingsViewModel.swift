//
//  SettingsViewModel.swift
//  Five
//
//  Created by Mark Wong on 5/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class SettingsViewModel {

	let cellId = "SettingsCellId"
	
    let menu = [
        "Task Limit",
		"Stats",
		"Yesterday's Review",
        "About",
        "Review App (fix link)",
        "Contact / Feedback",
    ]
    
    // Device parameters
    let appName = AppMetaData.name
    let appVersion = AppMetaData.version
    let deviceType = UIDevice().type
    let systemVersion = UIDevice.current.systemVersion

    // Email parameters
    let emailToRecipient = "hello@whizbangapps.xyz"
    let emailSubject = "Five App Feedback"
    func emailBody() -> String {
        return """
        </br>
        </br>\(appName): \(appVersion!)\n
        </br>iOS: \(systemVersion)
        </br>Device: \(deviceType.rawValue)
        """
    }
	
	func registerTableViewCell(_ tableView: UITableView) {
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
	}
	
	func tableViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = menu[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = .clear
		
		// chevron set up
		let image = UIImage(named: "ChevronRight.png")?.withRenderingMode(.alwaysTemplate)
		let chevron = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.height * 0.5, height: cell.frame.height * 0.5))
		chevron.image = image
		cell.accessoryView = chevron
		cell.tintColor = UIColor.white //color of the chevron
        return cell
	}
}

// to be refactored
struct AppMetaData {
    
    static let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    
    static let build = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
    
    static let name = Bundle.appName()
    
}

extension Bundle {
    static func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let version : String = dictionary["CFBundleName"] as? String {
            return version
        } else {
            return ""
        }
    }
}
