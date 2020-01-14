//
//  Bundle+Extension.swift
//  Shortlist
//
//  Created by Mark Wong on 14/11/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

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
