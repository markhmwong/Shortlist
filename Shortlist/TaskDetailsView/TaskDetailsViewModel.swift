//
//  TaskDetailsViewModel.swift
//  Shortlist
//
//  Created by Mark on 10/5/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import CoreData

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
        item.value.complete = !item.value.complete
        
        // save object state
        coreData.saveContext()
        
        // handle view dismissal and animations
        completionHandler(item.value)
    }
	
}
