//
//  StaticNotification.swift
//  Shortlist WatchKit Extension
//
//  Created by Mark Wong on 22/2/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import WatchKit
import UserNotifications

class StaticNotificationController: WKUserNotificationInterfaceController {
	
	@IBOutlet weak var AlertLabel: WKInterfaceLabel!
	
	override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func didReceive(_ notification: UNNotification) {
        // This method is called when a notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
    }
	
}
