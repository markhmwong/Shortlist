//
//  TaskCharacterLimits.swift
//  Shortlist
//
//  Created by Mark Wong on 11/11/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

// Character limit globals for the text fields. In particular for entering the task name, details and categories.
struct TaskCharacterLimits {
	static let taskNameMinimumCharacterLimit: Int = 1
	static let taskNameMaximumCharacterLimit: Int = 80
	
	static let taskDetailsMinimumCharacterLimit: Int = 1
	static let taskDetailsMaximumCharacterLimit: Int = 480
	
	static let taskCategoryMinimumCharacterLimit: Int = 1
	static let taskCategoryMaximumCharacterLimit: Int = 25
}
