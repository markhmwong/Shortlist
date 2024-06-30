//
//  CoreDataStack+Extension.swift
//  Shortlist
//
//  Created by Mark Wong on 16/6/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import Foundation

extension CoreDataStack {
    func createMockItems() {
        for i in 0...5 {
            let item = SLTask(context: moc!)
            item.name = "Clean storm drain \(i)"
            item.createdAt = Date()
            item.id = UUID()
            item.lat = 1.0
            item.long = 1.0
            let status = SLStatus(context: moc!)
            status.name = TaskStatus.Active.rawValue
            item.taskToStatus = status
            item.taskDescription = "Description"
            item.taskToCategory = SLCategory(context: moc!)
            item.taskToCategory?.name = "test category"
        }
        self.saveContext()
    }
}
