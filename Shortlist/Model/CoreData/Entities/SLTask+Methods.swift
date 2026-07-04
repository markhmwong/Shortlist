//
//  SLTask+Methods.swift
//  Shortlist
//
//  Created by Mark Wong on 29/6/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import Foundation

extension SLTask {
    func newTask(name: String, media: String? = nil, priority: TaskPriorityLevel = .high, reminder: Date? = nil, taskDescription: String? = nil, category: Int16 = 0) {
        self.createdAt = Date.now
        self.id = UUID()
        self.name = name
        self.media = media
        self.lat = 0.0
        self.long = 0.0
        self.priority = Int16(priority.rawValue)
        self.reminder = reminder
        self.taskDescription = taskDescription

        self.taskToStatus = SLStatus(context: managedObjectContext!)
        self.taskToStatus?.name = TaskStatus.Incomplete.rawValue
        self.taskToStatus?.statusToTask = self

        self.taskToCategory = SLCategory(context: managedObjectContext!)
        self.taskToCategory?.type = category
    }
}
