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
        guard let moc = moc else { return }
        let names = ["Buy groceries", "Call the dentist", "Finish report"]
        for (i, name) in names.prefix(3).enumerated() {
            let task = SLTask(context: moc)
            task.newTask(name: name, priority: TaskPriorityLevel(rawValue: i) ?? .high)
        }
        saveContext()
    }
}
