//
//  TaskListViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 13/4/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import Foundation

class TaskListViewModel: NSObject {
    
    var coreDataStack: CoreDataStack? = nil
    
    init(coreDataStack: CoreDataStack? = nil) {
        self.coreDataStack = coreDataStack
        super.init()
    }
    
}
