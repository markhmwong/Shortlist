//
//  TaskRowController.swift
//  Five WatchKit Extension
//
//  Created by Mark Wong on 31/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import WatchKit
import WatchConnectivity

enum Priority: Int16 {
	case high = 0
	case medium
	case low
}

struct PriorityColor {
	static var highColor: UIColor = UIColor(red:1.00, green:0.00, blue:0.30, alpha:1.0).adjust(by: 0.0)!
	static var mediumColor: UIColor = UIColor(red:0.86, green:0.50, blue:0.25, alpha:1.0).adjust(by: -10.0)!
	static var lowColor: UIColor = UIColor(red:0.35, green:0.53, blue:0.82, alpha:1.0).adjust(by: -15.0)!
	static var noneColor: UIColor = UIColor.black
}

class TaskRowController: NSObject {
    @IBOutlet weak var taskLabel: WKInterfaceLabel!
    @IBOutlet weak var taskButton: WKInterfaceButton!
	@IBOutlet weak var categoryLabel: WKInterfaceLabel! // doubles as the reminder label
	@IBOutlet weak var group: WKInterfaceGroup!
	
	
	var updateDataSource: ((TaskStruct) -> ())? = nil
    
    var task: TaskStruct? {
        didSet {
			
			taskRowColor(task?.priority ?? 0)
			let image = UIImage(named: "TaskButtonEnabled")?.withRenderingMode(.alwaysTemplate)

            if (task!.complete) {
                taskButton.setBackgroundImage(image?.imageWithColor(color1: .white))
            } else {
                taskButton.setBackgroundImage(image?.imageWithColor(color1: UIColor.white.adjust(by: -100.0)!))
            }
            guard let task = task else {
                taskLabel.setText("unknown task")
                return
            }
			
            taskLabel.setText(task.name)
			
			if (Date().timeIntervalSince(task.reminder) <= 0) {
				categoryLabel.setText("⏰ \(task.reminder.timeToString())")
				
			} else {
				categoryLabel.setText(task.category)
			}
			
        }
    }
	
	func taskRowColor(_ priority: Int16) {
		switch Priority.init(rawValue: priority) {
			case .high:
				group.setBackgroundColor(PriorityColor.highColor)
			case .medium:
				group.setBackgroundColor(PriorityColor.mediumColor)
			case .low:
				group.setBackgroundColor(PriorityColor.lowColor)
			case .none:
				group.setBackgroundColor(PriorityColor.noneColor)
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
        updateDataSource?(task)
    }

}
