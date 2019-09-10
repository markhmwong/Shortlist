//
//  MainViewModel.swift
//  Five
//
//  Created by Mark Wong on 16/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class MainViewModel {
    
    let taskListCellId = "taskCellId"
    
    var dayEntity: Day? = nil {
        didSet {
            guard let dayToTask = dayEntity?.dayToTask else {
                taskDataSource = []
                return
            }
            taskDataSource = dayToTask.allObjects as! [Task]
        }
    }
    
    // deprecated
    var taskDataSource: [Task] = [] {
        didSet {
            taskDataSource.sort { (a, b) -> Bool in
                return a.priority < b.priority
            }
        }
    }
    
    let taskSizeLimit: Int = 100
    
    let cellHeight: CGFloat = 70.0
}
