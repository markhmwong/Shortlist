//
//  TaskList.swift
//  Five
//
//  Created by Mark Wong on 30/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

// Apple Watch struct to transform the data
struct TaskStruct: Codable {
    private(set) var id: Int16
    var name: String
    var complete: Bool
    var priority: Int16 // to do
}
