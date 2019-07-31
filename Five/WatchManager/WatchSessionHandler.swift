//
//  SessionHandler.swift
//  Friday
//
//  Created by Mark Wong on 10/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchSessionHandler : NSObject {
    
    static let shared = WatchSessionHandler()
    
    private var session = WCSession.default
    
    private lazy var sessionDelegater: WatchSessionDelegater = {
        return WatchSessionDelegater()
    }()
    
    override init() {
        super.init()
        
        // 3: Start and avtivate session if it's supported
        if isSupported() {
            session.delegate = sessionDelegater
            session.activate()
        }
        
        print("isPaired?: \(session.isPaired), isWatchAppInstalled?: \(session.isWatchAppInstalled)")
    }
    
    func isSupported() -> Bool {
        return WCSession.isSupported()
    }
    
    func isReachable() -> Bool {
        return session.isReachable
    }
    
    func sendObjectWith(jsonData: Data) {
        session.sendMessageData(jsonData, replyHandler: { (data) in
            print("sent")
        }) { (err) in
            print("error sending json data \(err)")
        }
    }
    
    func updateApplicationContext(with data: Data) {
        do {
            try session.updateApplicationContext(["TaskListObject" : data, "force_send" : UUID().uuidString])
        } catch (let err) {
            print("\(err) could not update context")
        }
    }
}
