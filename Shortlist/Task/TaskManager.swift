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
    
    public init(coreDataStack: CoreDataStack) {
        self.coreData = coreDataStack
        super.init()
    }
    
    //TODO: define
    public func dailyTaskLimitExceeded() -> Bool {
        return false
    }
    
    //TODO: define
    public func totalTasks() -> Int {
        return 0
    }

	/// For use in settings to define the maximum allowable tasks
	public func totalAllowableTasks() -> Int16 {
		return SettingsManager.shared.fetchTaskLimit()
	}

	/// priority
	public func priorityList() -> [TaskPriorityLevel] {
		return [.low, .medium, .high, .critical]
	}
}


