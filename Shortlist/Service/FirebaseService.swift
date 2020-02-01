//
//  FireBaseService.swift
//  Shortlist
//
//  Created by Mark Wong on 31/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation
import Firebase

enum DatabaseReferenceKeys: String {
    case rooms = "rooms"
    case userRooms = "userRooms"
    case users = "users"
    case roomsCheck = "roomsCheck"
}

class FirebaseService {
	
	private var ref: DatabaseReference = Database.database().reference(fromURL: "https://shortlist-d8e3d.firebaseio.com/")
	
	//separate?
	private var queue = DispatchGroup()
	
	init(dataBaseUrl: String) {
		self.ref = Database.database().reference(fromURL: dataBaseUrl)
	}
	
	func authenticateAnonymously() {
		Auth.auth().signInAnonymously() { (authResult, error) in
			let user = authResult?.user
			_ = user?.isAnonymous  // true

//			self.awaitToken.enter()
//			InstanceID.instanceID().instanceID { (result, error) in
//				if let error = error {
//					print("Error fetching remote instance ID: \(error)")
//				} else if let result = result {
//					print("Remote instance ID token: \(result.token)")
//				}
//				self.awaitToken.leave()
//			}
//
//			self.awaitToken.notify(queue: .main, execute: {
//				let refTasks = self.ref.child("stats")
//
//				refTasks.observeSingleEvent(of: .value) { (snapshot) in
//					print(snapshot)
//					guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
//					print(dictionary["globalTasks"])
//				}
//			})
		}
	}
	
	func getGlobalTasks(completionHandler: @escaping (Int) -> Void) {
		let refTasks = self.ref.child("stats")
		var globalTask: Int = 0
		let failedValue: Int = 0
		queue.enter()
		refTasks.observeSingleEvent(of: .value) { (snapshot) in
			print(snapshot)
			guard let dictionary = snapshot.value as? [String: Any] else {
				globalTask = failedValue
				self.queue.leave()
				return
			}
			guard let task = dictionary["globalTasks"] as! Int? else {
				globalTask = failedValue
				self.queue.leave()
				return
			}
			globalTask = task
			self.queue.leave()
		}
		
		queue.notify(queue: .main) {
			completionHandler(globalTask)
		}
	}
}
