//
//  TaskManage.swift
//  Shortlist
//
//  Created by Mark Wong on 7/5/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import Foundation

class TaskManager: NSObject {
    
    //core data stack
    private var coreData: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreData = coreDataStack
        super.init()
    }
    
    //TODO: define
    func dailyTaskLimitExceeded() -> Bool {
        return false
    }
    
    //TODO: define
    func totalTasks() -> Int {
        return 0
    }
    
}
