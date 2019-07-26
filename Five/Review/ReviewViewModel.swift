//
//  ReviewViewModel.swift
//  Five
//
//  Created by Mark Wong on 26/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

class ReviewViewModel {
    
    let reviewCellId = "reviewCellId"
    
    var dayEntity: Day? = nil {
        didSet {
            taskDataSource = dayEntity?.dayToTask?.allObjects as! [Task]
        }
    }
    
    var taskDataSource: [Task] = [] {
        didSet {
            taskDataSource.sort { (a, b) -> Bool in
                return a.id < b.id
            }
        }
    }
    
    let taskSize: Int = 5
    
    var incompleteTasks: Int {
        let count = 0
        for task in taskDataSource {
            if (task.complete) {
                count += 1
            }
        }
        return count
    }
}
