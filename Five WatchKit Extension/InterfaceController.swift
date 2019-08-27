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
    
    private var tableDataSource: [TaskStruct]? = nil {
        didSet {
            guard let tableDataSource = tableDataSource else { return }
            self.reloadTable(with: tableDataSource)
        }
    }
    
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
//        emptyData()
        loadDate()
    }
    
    override func didAppear() {
        super.didAppear()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        print("WillActivate")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        print("didDeactivate")
    }
    
//    func emptyData() {
//        self.taskTable.setNumberOfRows(1, withRowType: "TaskRow")
//        guard let controller = self.taskTable.rowController(at: 0) as? TaskRowController else { return }
//        controller.taskLabel.setText("No tasks available")
//    }
    
    func loadDate() {
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
    
    // data: [TaskStruct] is sorted.
    func reloadTable(with data: [TaskStruct]) {
        print("reloadTable")
        taskTable.setNumberOfRows(data.count, withRowType: "TaskRow")
        for index in 0..<taskTable.numberOfRows {
            guard let controller = taskTable.rowController(at: index) as? TaskRowController else { continue }
            controller.task = data[index]
            //task button closure
            controller.updateDataSource = { [unowned self] (task) in
                self.tableDataSource?[Int(task.id)] = task
                do {
                    let encodedData = try JSONEncoder().encode(self.tableDataSource)
                    let dataDict = ["UpdateTaskFromWatch": encodedData]
//                    try self.watchSession?.updateApplicationContext(dataDict)
                } catch (let err) {
                    print("Error encoding data from watch: \(err)")
                }
            }
        }
    }
}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session activation did complete")
        session.sendMessage(["requestPhoneData" : 1], replyHandler: { (response) in

            let taskList = response as! [String : Data]
            if let data = taskList["WatchDidLoadResponse"] {
                do {
                    let decodedData = try JSONDecoder().decode([TaskStruct].self, from: data)
                    let sortedData = decodedData.sorted { (taskA, taskB) -> Bool in
                        return taskA.id < taskB.id
                    }
                    // Table reloads in didSet method of tableDataSource var
                    self.tableDataSource = sortedData
                } catch (let err) {
                    print("Unable to decode \(err)")
                }
            }
        }, errorHandler: { (err) in
            print("Send Message Error \(err) ")
        })
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        print("didRecieve Message Data")
        print(messageData)
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("watch received app context: ", applicationContext)
        let key = applicationContext.keys.sorted()
//         <- sort this first.
//        the data is sending but the order of the dictionary is incorrect, the force_send key sometimes is in index 0

        switch key.first {
            case ReceiveApplicationContextKey.TaskListObject.rawValue:
                let jsonDecoder = JSONDecoder()
                do {
                    let data = applicationContext[ReceiveApplicationContextKey.TaskListObject.rawValue] as! Data
                    let decodedData = try jsonDecoder.decode([TaskStruct].self, from: data)
                    let sortedData = decodedData.sorted { (taskA, taskB) -> Bool in
                        return taskA.id < taskB.id
                    }
                    self.tableDataSource = sortedData
                } catch (let err) {
                    print("\(err)")
                }
            case ReceiveApplicationContextKey.UpdateTaskListFromPhone.rawValue:
                let jsonDecoder = JSONDecoder()
                do {
                    let data = applicationContext[ReceiveApplicationContextKey.UpdateTaskListFromPhone.rawValue] as! Data
                    let decodedData = try jsonDecoder.decode([TaskStruct].self, from: data)
                    let sortedData = decodedData.sorted { (taskA, taskB) -> Bool in
                        return taskA.id < taskB.id
                    }
                    self.tableDataSource = sortedData
                } catch (let err) {
                    print("\(err)")
                }
        default:
            ()
        }
    }
}


enum ReceiveApplicationContextKey: String {
    case ForceSend = "9_ForceSend"
    case TaskListObject = "0_TaskListObject"
    case UpdateTaskListFromPhone = "0_UpdateTaskListFromPhone"
}
