//
//  CoreDataStack+Extension.swift
//  Shortlist
//
//  Created by Mark Wong on 16/6/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import Foundation
import CoreData

extension CoreDataStack {

    /// Returns all SLTask records created yesterday (any status).
    func fetchYesterdayTasks() -> [SLTask] {
        guard let moc else { return [] }
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let startOfYesterday = Calendar.current.startOfDay(for: yesterday)
        let startOfToday = Calendar.current.startOfDay(for: Date())

        let request: NSFetchRequest<SLTask> = SLTask.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "taskToStatus.name IN %@",
                        [TaskStatus.Incomplete.rawValue, TaskStatus.Complete.rawValue]),
            NSPredicate(format: "createdAt >= %@ AND createdAt < %@",
                        startOfYesterday as NSDate, startOfToday as NSDate),
        ])
        return (try? moc.fetch(request)) ?? []
    }

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
