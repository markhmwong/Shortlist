//
//  TaskRowController.swift
//  Five WatchKit Extension
//
//  Created by Mark Wong on 31/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import WatchKit

class TaskRowController: NSObject {
    @IBOutlet weak var taskLabel: WKInterfaceLabel!

    var task: TaskStruct? {
        didSet {
            guard let task = task else {
                taskLabel.setText("unknown task")
                return
            }
            taskLabel.setText(task.name)
        }
    }
    
}
