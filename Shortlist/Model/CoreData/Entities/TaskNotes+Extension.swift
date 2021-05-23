//
//  TaskNotes+Extension.swift
//  Shortlist
//
//  Created by Mark Wong on 22/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import CoreData

extension TaskNote {
	
	func createNotes(note: String, isButton: Bool = false) {
		self.isButton = false
		self.note = note
	}
	
}
