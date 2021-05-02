//
//  NewTaskViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 29/11/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

/*

	MARK: - New Task View Model

	One view model passed between the new task guide

*/
class NewTaskViewModel: NSObject {
    
    struct TempTask {
        var title: String = "A new task to focus on.."
        var priority: Priority = .high
        var redact: RedactStyle = .none
        var reminder: DateComponents = DateComponents(hour: 12, minute: 0)
    }
    
    private var persistentContainer: PersistentContainer
    
    var tempTask: TempTask
    
    init(persistentContainer: PersistentContainer) {
        self.persistentContainer = persistentContainer
        tempTask = TempTask()
        super.init()
    }
    
    func createTask() {
        let task = Task(context: persistentContainer.viewContext)
        task.create(context: persistentContainer.viewContext, taskName: "🚀 Quick tasks that aren't necessarily important or something to remind yourself, like catching up on TV shows or replying to emails.", categoryName: "Uncategorized", createdAt: Calendar.current.today(), reminderDate: Calendar.current.today(), priority: Int(Priority.low.value), redact: 0)
        task.details = "The limit on a low priority task is 1 - 3. Quick tasks that don't need a lot of time spent on."
        if let day = persistentContainer.fetchDayManagedObject(forDate: Calendar.current.today()) {
            day.addToDayToTask(task)
            persistentContainer.saveContext()
        }
    }
    
}
