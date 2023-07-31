//
//  AppMetaData.swift
//  Shortlist
//
//  Created by Mark Wong on 14/11/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

struct AppMetaData {
    
    static let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    
    static let build = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
    
    static let name = Bundle.appName()
        
    static let email: String = "hello@whizbangapps.xyz"
    
    static let twitterHandle: String = "@_markwong_"
}
