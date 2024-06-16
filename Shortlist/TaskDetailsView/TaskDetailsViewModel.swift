//
//  TaskDetailsViewModel.swift
//  Shortlist
//
//  Created by Mark on 10/5/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import CoreData

enum SLTaskStatus: String {
    case Complete
    case Incomplete
    case Backlog
    case Active
}

class TaskDetailsViewModel: NSObject {
	
	let item: Binding<SLTask>
	
    let coreData: CoreDataStack
    
    init(item: SLTask, coreData: CoreDataStack) {
        self.coreData = coreData
		self.item = Binding(value: item)
		super.init()
	}
	
    func taskIsComplete(completionHandler: (SLTask) -> ()) {
        // handle data
        let status = SLTaskStatus(rawValue: item.value.taskToStatus?.name ?? "Incomplete")
        
        switch status {
        case .Complete:
            item.value.taskToStatus?.name = SLTaskStatus.Incomplete.rawValue
        case .Incomplete:
            item.value.taskToStatus?.name = SLTaskStatus.Complete.rawValue
        case .Backlog:
            ()
        case .none, .Active:
            () 
        }
        
        // save object state
        coreData.saveContext()
        
        // handle view dismissal and animations
        completionHandler(item.value)
    }
}
