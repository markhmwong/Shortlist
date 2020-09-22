//
//  MainCollectionView+Meta.swift
//  Shortlist
//
//  Created by Mark Wong on 23/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

enum TaskSection: Int, CaseIterable {
	case high = 0
	case medium
	case low
}

enum RedactState: Int {
	case censor = 0
	case disclose
}

enum RedactStyle: Int {
	case disclose = 0 //hidden
	case highlight // hidden
	case star // total transparency
}

struct TaskItem: Hashable {
	
	var id: UUID = UUID()
	var title: String
	var notes: String
	var priority: Priority
	var completionStatus: Bool
	var reminder: String
//	var redacted: RedactState // because it's stored in Core Data and CoreData doesn't store enums, we'll use an integer to represent it and then assign it to the enum
//	var redactStyle: Int?
	var redaction: RedactComponent
	
	static func == (lhs: TaskItem, rhs: TaskItem) -> Bool {
		return lhs.id == rhs.id
	}
}

// Core Data for redact
// an attribute to represent the style and whether or not it is censored

// enum -> Struct -> state pattern
