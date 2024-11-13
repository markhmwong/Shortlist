//
//  Version.swift
//  Shortlist
//
//  Created by Mark Wong on 13/11/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import Foundation

// TODO: This should move to WhizbangKit
class Version {

	/// Return the version of the app as Integer components
	/// - Returns: major, minor, patch as Integer
	static func getAppVersionComponentsAsIntegers() -> (major: Int, minor: Int, patch: Int)? {
		guard let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
			return nil
		}

		let components = versionString.split(separator: ".").compactMap { Int($0) }

		guard components.count == 3 else {
			return nil
		}

		let (major, minor, patch) = (components[0], components[1], components[2])
		return (major, minor, patch)
	}

	/// Return the version of the app as String components
	///  - Returns: major, minor, patch as String
	static func getAppVersionComponentsAsStrings() -> (major: String, minor: String, patch: String)? {
		guard let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
			return nil
		}

		let components = versionString.split(separator: ".").compactMap { version in
			String(version)
		}

		guard components.count == 3 else {
			return nil
		}

		let (major, minor, patch) = (components[0], components[1], components[2])
		return (major, minor, patch)
	}
}
