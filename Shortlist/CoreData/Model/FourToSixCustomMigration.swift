//
//  4to6CustomMigration.swift
//  Shortlist
//
//  Created by Mark Wong on 9/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation
import CoreData

class FourToSixCustomMigration: NSEntityMigrationPolicy {
	
	@objc
	func toString(value: Int16) -> String {
		return "\(value)"
	}
	
}
