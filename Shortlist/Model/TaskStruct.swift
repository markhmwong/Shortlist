//
//  TaskList.swift
//  Five
//
//  Created by Mark Wong on 30/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

// Apple Watch struct to transform the data
struct TaskStruct: Codable, Equatable {
	var date: Date //id
    var name: String
    var complete: Bool
    var priority: Int16
	
	static func ==(lhs: TaskStruct, rhs: TaskStruct) -> Bool {
		return lhs.date == rhs.date
	}
}
