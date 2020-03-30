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
		
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        if (message.keys.contains("requestPhoneData")) {
            let todayNSManagedObject = persistentContainer?.fetchDayManagedObject(forDate: Calendar.current.today())
            let taskList: [Task] = todayNSManagedObject?.dayToTask?.allObjects as! [Task]
            var dataList: [TaskStruct] = []
            for task in taskList {
				let newTask: TaskStruct = TaskStruct(date: task.createdAt! as Date, name: task.name!, complete: task.complete, priority: task.priority, category: task.category, reminder: task.reminder! as Date, reminderState: task.reminderState, details: task.details ?? "")
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
        persistentContainer?.saveContext()

    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        
    }
    
	// updating phone data
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
		let data = applicationContext["UpdateTaskFromWatch"] as! Data
        do {
			
            let decodedData = try JSONDecoder().decode([TaskStruct].self, from: data)

            let taskDataPhone = persistentContainer?.fetchDayEntity(forDate: Calendar.current.today()) as! Day
//            taskDataPhone.taskLimit = taskDataPhone.taskLimit + 1 // to be fixed
			guard let dayToTask = taskDataPhone.dayToTask else { return }
            let tasks = dayToTask.sortedArray(using: [NSSortDescriptor(key: "createdAt", ascending: true)]) as! [Task]
            for watchTask in decodedData {
				for phoneTask in tasks {
					if (phoneTask.createdAt! as Date == watchTask.date) {
						phoneTask.complete = watchTask.complete
					}
				}
            }
			postNotificationOnMainQueueAsync(name: .watchDidUpdate)
        } catch (let err) {
            print("Unable to decode data from Watch\(err)")
        }
    }
	
	private func postNotificationOnMainQueueAsync(name: NSNotification.Name) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: name, object: nil)
        }
    }
}

extension Notification.Name {
    static let watchDidUpdate = Notification.Name("WatchDidUpdate")
}
