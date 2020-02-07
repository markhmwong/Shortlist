//
//  AppUpdate.swift
//  Shortlist
//
//  Created by Mark Wong on 7/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

final class ApplicationDetails: NSObject {
	
	static var shared: ApplicationDetails = ApplicationDetails()
	
	let kPreviousVersionId = "PreviousVersion"
	
	private override init() {
		super.init()
	}
	
	// use this function to figure out whether to show the update screen
	func hasCurrentVersionAltered() -> Bool {
		let version = currentVersion()
		
		guard let previousVersion = KeychainWrapper.standard.string(forKey: "PreviousVersion") else {
			KeychainWrapper.standard.set(version, forKey: kPreviousVersionId)
			return true
		}
		
		if (previousVersion == version) {
			return false
		} else {
			return true
		}
	}
	
	// app's version in string type
	func currentVersion() -> String {
		if let version: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
			return version
		}
		return "Unknown Version"
	}
	
	// app's version as Double
	func currentVersionAsDouble() -> Double {
		let version = currentVersion()
		return Double(version)!
	}
}


