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
        
        let today = Calendar.current.today()
        let monthNameFormatter = DateFormatter()
        monthNameFormatter.dateFormat = "MMMM"
        let monthString = monthNameFormatter.string(from: today)
        let todayNameFormatter = DateFormatter()
        todayNameFormatter.dateFormat = "dd"
        let todayString = todayNameFormatter.string(from: today)
        let str = "\(todayString) \(monthString)"
        
//        dateLabel.setText(str)
        
        dateLabel.setAttributedText(NSMutableAttributedString(string: "\(str)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.strokeWidth : -3.0, NSAttributedString.Key.strokeColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 22.0)!]))
        watchSession = WCSession.default
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
            let taskdata = try jsonDecoder.decode(TaskList.self, from: data)
            print(taskdata.date)
        } catch (let err) {
            print("\(err)")
        }
    }
}
