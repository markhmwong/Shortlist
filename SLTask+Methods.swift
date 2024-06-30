//
//  SLTask+Methods.swift
//  Shortlist
//
//  Created by Mark Wong on 29/6/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import Foundation

extension SLTask {
    func newTask(name: String, media: String? = nil, priority: PriorityLevel = .high, reminder: Date? = nil, taskDescripion: String? = nil, category: String = "General") {
        self.createdAt = Date.now
        self.id = UUID()
        self.name = name

        // TODO: media
        self.media = nil // to do
        
        // TODO: Location
        self.lat = 0.0
        self.long = 0.0
       
        #if DEBUG
        let random = Int16.random(in: 0...2)
        self.priority = random
        #else
        self.priority = Int16(priority.rawValue)
        #endif
        self.reminder = reminder
        self.taskDescription = taskDescription
        
        self.taskToStatus = SLStatus(context: managedObjectContext!)
        self.taskToStatus?.name = TaskStatus.Incomplete.rawValue
        self.taskToStatus?.statusToTask = self
        
        self.taskToCategory = SLCategory(context: managedObjectContext!)
        self.taskToCategory?.name = category
    }
}
