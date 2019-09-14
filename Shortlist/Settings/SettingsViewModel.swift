//
//  SettingsViewModel.swift
//  Five
//
//  Created by Mark Wong on 5/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class SettingsViewModel {

    let menu = [
        "Task Limit",
        "About",
        "Review",
        "Contact",
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
