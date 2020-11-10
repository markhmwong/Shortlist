//
//  TaskFullDetailInterfaceController.swift
//  Shortlist WatchKit Extension
//
//  Created by Mark Wong on 12/3/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class TaskFullDetailInterfaceController: WKInterfaceController {

	@IBOutlet weak var taskName: WKInterfaceLabel!
	@IBOutlet weak var taskNotes: WKInterfaceLabel!
	@IBOutlet weak var taskCategory: WKInterfaceLabel!
	@IBOutlet weak var taskReminder: WKInterfaceLabel!
	@IBOutlet weak var taskGroup: WKInterfaceGroup!
	@IBOutlet weak var markAsDoneButton: WKInterfaceButton!
	
	var task: TaskStruct? {
		didSet {
			loadData(task: task)
		}
	}
	
	var dataSource: [TaskStruct]? = nil
	
    private var watchSession: WCSession? {
        didSet {
            if let session = watchSession {
                session.delegate = self
                session.activate()
            }
        }
    }
	
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        watchSession = WCSession.default
		
		let dictData = context as! [String: Any]
		let row = dictData["row"] as! Int
		dataSource = dictData["data"] as? [TaskStruct]
		
		// Initial
		task = dataSource?[row]
    }
	
	func loadData(task: TaskStruct?) {
		if let task = task {
			taskName.setText("\(task.name)")
			
			taskNotes.setText("\(task.details)")
			taskCategory.setText(task.category)
			if (task.reminderState) {
				taskReminder.setText("⏰ \(task.reminder.timeToStringInHrMin())")
			} else {
				taskReminder.setText("⏰ No Reminder Set")
			}
			taskGroup.setBackgroundColor(PriorityColor.colorForRow(task.priority))
			
			// setup mark as done button
			if task.complete {
				markAsDoneButton.setBackgroundColor(UIColor.green.darker())
			} else {
				markAsDoneButton.setBackgroundColor(UIColor.black.adjust(by: 10))
			}
		} else {
			taskName.setText("Task could be read")
			
			taskNotes.setText("")
			taskCategory.setText("")
			taskReminder.setText("")
			taskGroup.setBackgroundColor(PriorityColor.colorForRow(task?.priority ?? 4))
			
			// setup mark as done button
			if task?.complete ?? false {
				markAsDoneButton.setBackgroundColor(UIColor.white)
			} else {
				markAsDoneButton.setBackgroundColor(UIColor.black)
			}
		}

	}
	
    override func didAppear() {
        super.didAppear()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

	@IBAction func handleMarkAsDone() {
		task?.complete = !(task?.complete ?? true)
		updateDataSource()
	}
	
	func updateDataSource() {
		// repeated code
		guard let dataSource = self.dataSource, let task = task else { return }
		for (index, data) in dataSource.enumerated() {
			if (data == task) {
				self.dataSource?[index] = task
			}
		}
		do {
			let encodedData = try JSONEncoder().encode(self.dataSource)
			let dataDict = ["UpdateTaskFromWatch": encodedData]
			try self.watchSession?.updateApplicationContext(dataDict)
		} catch (_) {
			//
		}
	}
}

extension TaskFullDetailInterfaceController: WCSessionDelegate {
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		// not needed?
	}
	

}
