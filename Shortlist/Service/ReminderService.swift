//
//  ReminderService.swift
//  Shortlist
//
//  Created by Mark Wong on 1/4/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import EventKit

class ReminderService: NSObject {
	
	var eventStore: EKEventStore
	
	override init() {
		eventStore = EKEventStore()
		super.init()
		requestAccess { (accessState, err) in
			
		}
	}
	
	private func requestAccess(completion: @escaping EKEventStoreRequestAccessCompletionHandler) {
        eventStore.requestAccess(to: EKEntityType.reminder) { (accessGranted, error) in
            completion(accessGranted, error)
        }
    }
	
	static func getReminderAuthorizationStatus() -> EKAuthorizationStatus {
		return EKEventStore.authorizationStatus(for: EKEntityType.reminder)
	}
	
	func getEventAuthorizationStatus() -> EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: EKEntityType.event)
    }
	
	func fetchReminders(completionHandler: @escaping ([EKReminder]?) -> Void) {
		let calendars = eventStore.calendars(for: .reminder)

		let predicate: NSPredicate? = self.eventStore.predicateForReminders(in: calendars)
		eventStore.fetchReminders(matching: predicate!) { (reminder) in
			
//			guard let r = reminder else { return }
				
//				//notes
//				//startDate
//				//endData
//				//alarms
				//priority
				//title

			completionHandler(reminder)
		}

	}
	
	func commitChanges(reminder: EKReminder) {
		do {
			try eventStore.save(reminder, commit: true)
		} catch (let err) {
			print(err)
		}
	}
}
