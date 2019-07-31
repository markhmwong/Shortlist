//
//  PhoneSessionManager.swift
//  Friday WatchKit Extension
//
//  Created by Mark Wong on 10/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation
import WatchConnectivity

class PhoneSessionManager: NSObject {
    
    static let shared = PhoneSessionManager()

    private let session: WCSession = WCSession.default
    
    override init() {
        super.init()
        
        if isSupported() {
            startSession()
        }
    }
    
    func startSession() {
        session.activate()
    }
    
    func requestApplicationContext() {
        // Send a message with a key that your phone expects. You can organize your constants in a
        // series of structs like I did, or hard code a string instead of Key.Request.ApplicationContext.
//        sendMessage([Key.Request.ApplicationContext: true], replyHandler: nil, errorHandler: nil)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        // Request new application context when reachability changes.
        requestApplicationContext()
    }
    
    func isReachable() -> Bool {
        return session.isReachable
    }
    
    func isSupported() -> Bool {
        return WCSession.isSupported()
    }
}

// MARK: Interactive Messaging
extension PhoneSessionManager {
    
    // App has to be reachable for live messaging.
    private var validReachableSession: WCSession? {
        
        if session.isReachable {
            return session
        }
        return nil
    }
    
    // Sender
    func sendMessage(message: [String : Any], replyHandler: (([String : Any]) -> Void)? = nil, errorHandler: ((NSError) -> Void)? = nil) {
        validReachableSession?.sendMessage(message, replyHandler: replyHandler, errorHandler: { (err) in
            print("Error sending message \(err)")
        })
    }
    

}
