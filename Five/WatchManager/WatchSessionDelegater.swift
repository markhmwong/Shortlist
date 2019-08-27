//
//  SessionDelegater.swift
//  Friday
//
//  Created by Mark Wong on 11/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchSessionDelegater: NSObject, WCSessionDelegate {
    
    var persistentContainer: PersistentContainer?
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("did become active")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("did become inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("did deactivate")
        session.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        print("did receive from watch")

        
//        let jsonDecoder = JSONDecoder()
//        do {
////            let fridayData = try jsonDecoder.decode(Friday.self, from: messageData)
////            print(fridayData.isTodayFriday)
//        } catch (let err) {
//            print("\(err)")
//        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("didreceivemessage")
        persistentContainer?.saveContext()
        
        if (message.keys.contains("requestPhoneData")) {
            let todayNSManagedObject = persistentContainer?.fetchDayManagedObject(forDate: Calendar.current.today())
            let taskList: [Task] = todayNSManagedObject?.dayToTask?.allObjects as! [Task]
            var dataList: [TaskStruct] = []
            for task in taskList {
                let newTask: TaskStruct = TaskStruct(id: task.id, name: task.name!, complete: task.complete)
                dataList.append(newTask)
            }

            do {
                let encodedData = try JSONEncoder().encode(dataList)
                print("dataList \(dataList.count)")
                replyHandler(["WatchDidLoadResponse" : encodedData])
            } catch (let err) {
                print("Error encoding taskList \(err)")
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        print("messageData")
        
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("did receive application context from watch")
        let data = applicationContext["UpdateTaskFromWatch"] as! Data
        do {
            let decodedData = try JSONDecoder().decode([TaskStruct].self, from: data)

            let taskDataPhone = persistentContainer?.fetchDayEntity(forDate: Calendar.current.today()) as! Day
            taskDataPhone.taskLimit = taskDataPhone.taskLimit + 1
            let tasks = taskDataPhone.dayToTask?.sortedArray(using: [NSSortDescriptor(key: "id", ascending: true)]) as! [Task]
            for task in decodedData {
                tasks[Int(task.id)].complete = task.complete
            }
            persistentContainer?.saveContext(backgroundContext: nil)
        } catch (let err) {
            print("Unable to decode data from Watch\(err)")
        }
    }
}
