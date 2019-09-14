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
    
    //pass core data here
    private var persistentContainer: PersistentContainer? {
        didSet {
            sessionDelegater.persistentContainer = persistentContainer
        }
    }
    
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
    
    func initPersistentContainer(with container: PersistentContainer) {
        persistentContainer = container
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
            try session.updateApplicationContext([ReceiveApplicationContextKey.TaskListObject.rawValue : data, ReceiveApplicationContextKey.ForceSend.rawValue : UUID().uuidString])
        } catch (let err) {
            print("\(err) could not update context")
        }
    }
    
    func updateApplicationContext(with key: String, data: Data) {
        do {
            try session.updateApplicationContext([key : data, ReceiveApplicationContextKey.ForceSend.rawValue : UUID().uuidString])
        } catch (let err) {
            print("\(err) could not update context")
        }
    }
}
