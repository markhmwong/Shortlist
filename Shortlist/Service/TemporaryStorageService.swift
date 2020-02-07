//
//  TemporaryStorage.swift
//  Shortlist
//
//  Created by Mark Wong on 6/2/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

class TemporaryStorageService: NSObject {
	
	static var shared: TemporaryStorageService = TemporaryStorageService()
	
	private var defaults: UserDefaults = UserDefaults.standard
	
	private let FIRST_LOAD_KEY: String = "FirstLoad"
	
	override init() {
		
	}
	
	func firstLoad() -> Bool {
		if (defaults.bool(forKey: FIRST_LOAD_KEY)) {
			// is not the first time loading
			return false
		}
		
		// first load. update value
		defaults.set(true, forKey: FIRST_LOAD_KEY)
		return true
	}
	
}
