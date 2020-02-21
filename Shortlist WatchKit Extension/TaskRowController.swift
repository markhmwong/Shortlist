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
	@IBOutlet weak var categoryLabel: WKInterfaceLabel! // doubles as the reminder label
	
    var updateDataSource: ((TaskStruct) -> ())? = nil
    
    var task: TaskStruct? {
        didSet {
            
            if (task!.complete) {
				let image = UIImage(named: "TaskButtonEnabled")?.withRenderingMode(.alwaysTemplate)
				let tintedImage = image?.imageWithColor(color1: .white)
                taskButton.setBackgroundImage(tintedImage)
            } else {
                taskButton.setBackgroundImage(UIImage(named: "TaskButtonDisabled"))
            }
            guard let task = task else {
                taskLabel.setText("unknown task")
                return
            }
			
            taskLabel.setText(task.name)
			
			if (Date().timeIntervalSince(task.reminder) <= 0) {
				categoryLabel.setText(task.category)
			} else {
				categoryLabel.setText("⏰ \(task.reminder.timeToString())")
			}
			
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

//extension UIImage {
//    func imageWithColor(color1: UIColor) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
//        color1.setFill()
//
//        let context = UIGraphicsGetCurrentContext()
//        context?.translateBy(x: 0, y: self.size.height)
//        context?.scaleBy(x: 1.0, y: -1.0)
//        context?.setBlendMode(CGBlendMode.normal)
//
//        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
//        context?.clip(to: rect, mask: self.cgImage!)
//        context?.fill(rect)
//
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return newImage!
//    }
//}
