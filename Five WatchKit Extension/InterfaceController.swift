//
//  InterfaceController.swift
//  Five WatchKit Extension
//
//  Created by Mark Wong on 16/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    @IBOutlet weak var taskTable: WKInterfaceTable!
    
//    var tasks tbd
    
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
        reloadData()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func reloadData() {
        
        watchSession?.sendMessage(["RequestData" : 1], replyHandler: { (response) in
            // grab response from iOS and parse data to table
            self.taskTable.setNumberOfRows(0, withRowType: "TaskRow")
        }, errorHandler: { (err) in
            print("\(err) ")
        })
        
        let today = Calendar.current.today()
        let monthNameFormatter = DateFormatter()
        monthNameFormatter.dateFormat = "MMMM"
        let monthString = monthNameFormatter.string(from: today)
        let todayNameFormatter = DateFormatter()
        todayNameFormatter.dateFormat = "dd"
        let todayString = todayNameFormatter.string(from: today)
        let str = "\(todayString) \(monthString)"

        dateLabel.setText(str)
    }

}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session activation did complete")
    }
    
//    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
//        print("didRecieve Message Data")
//        print(messageData)
//        let jsonDecoder = JSONDecoder()
//        do {
//            let taskList = try jsonDecoder.decode(TaskList.self, from: messageData)
//            print(taskList.date)
//        } catch (let err) {
//            print("\(err)")
//        }
//    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("watch received app context: ", applicationContext)
        let jsonDecoder = JSONDecoder()
        do {
            let data = applicationContext["TaskListObject"] as! Data
            let taskData = try jsonDecoder.decode([TaskStruct].self, from: data)
            print(taskData.count)
            taskTable.setNumberOfRows(3, withRowType: "TaskRow")
            
            for index in 0..<taskTable.numberOfRows {
                guard let controller = taskTable.rowController(at: index) as? TaskRowController else { continue }
                controller.task = taskData[index]
            }
            
        } catch (let err) {
            print("\(err)")
        }
    }
    
    
}
