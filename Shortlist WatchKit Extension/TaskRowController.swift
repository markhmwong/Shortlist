//
//  TaskRowController.swift
//  Five WatchKit Extension
//
//  Created by Mark Wong on 31/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import WatchKit
import WatchConnectivity

class TaskRowController: NSObject {
    @IBOutlet weak var taskLabel: WKInterfaceLabel!
    @IBOutlet weak var taskButton: WKInterfaceButton!
    
    var updateDataSource: ((TaskStruct) -> ())? = nil
    
    var task: TaskStruct? {
        didSet {
            
            if (task!.complete) {
                taskButton.setBackgroundImage(UIImage(named: "TaskButtonEnabled"))
            } else {
                taskButton.setBackgroundImage(UIImage(named: "TaskButtonDisabled"))
            }
            guard let task = task else {
                taskLabel.setText("unknown task")
                return
            }
            taskLabel.setText(task.name)
        }
    }
    
    @IBAction func taskComplete() {
        task!.complete = !task!.complete
        guard let task = task else { return }
        if (task.complete) {
            taskButton.setBackgroundImage(UIImage(named: "TaskButtonEnabled"))
        } else {
            taskButton.setBackgroundImage(UIImage(named: "TaskButtonDisabled"))
        }
        
        //Send updated data to phone
        print("updatetask")
        updateDataSource?(task)
    }

}
