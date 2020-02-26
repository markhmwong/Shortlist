//
//  FireBaseService.swift
//  Shortlist
//
//  Created by Mark Wong on 31/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation
import Firebase

enum RecordsUpdated {
	case Complete
	case Incomplete
}

class FirebaseService {
	
	private let GLOBAL_TASK_COUNT = "globalTaskCount"
	
	private let STATS_REF: String = "stats"
	
	private var ref: DatabaseReference = Database.database().reference(fromURL: "https://shortlist-d8e3d.firebaseio.com/")

	private var queue = DispatchGroup()
	
	var status: RecordsUpdated = .Incomplete
	
	init(dataBaseUrl: String?) {
		self.ref = Database.database().reference(fromURL: dataBaseUrl ?? "https://shortlist-d8e3d.firebaseio.com/")
	}
	
	func authenticateAnonymously() {
		Auth.auth().signInAnonymously() { (authResult, error) in
			let user = authResult?.user
			_ = user?.isAnonymous  // true

		}
	}
	
	func getGlobalTasks(completionHandler: @escaping (Int) -> ()) {
		let refStats = self.ref.child(STATS_REF)
		var globalTask: Int = 0
		let failedValue: Int = 0
		queue.enter()
		refStats.observeSingleEvent(of: .value) { (snapshot) in
			guard let dictionary = snapshot.value as? [String: Any] else {
				globalTask = failedValue
				self.queue.leave()
				return
			}
			guard let task = dictionary[self.GLOBAL_TASK_COUNT] as! Int? else {
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
	
	// Uses the transaction api to ensure the count is correct even when multiple sources attempt to update the value. This is important as we want the value to be updated correctly
	func sendTotalCompletedTasks(amount: Int, completionHandler: @escaping () -> Void) {
		
		let refStats = self.ref.child(STATS_REF)
		
		refStats.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
			if var stats: [String : Any] = currentData.value as? [String: Any] {
				var globalTaskCount: Int = stats[self.GLOBAL_TASK_COUNT] as? Int ?? 0
				
				globalTaskCount = globalTaskCount + amount
				
				stats[self.GLOBAL_TASK_COUNT] = globalTaskCount
				
				currentData.value = stats
				
				return TransactionResult.success(withValue: currentData)
			}
			return TransactionResult.success(withValue: currentData)
		}) { (err, state, dataSnapshot) in
			//error todo
			
		}
	}
}
