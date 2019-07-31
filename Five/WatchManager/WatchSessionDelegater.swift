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
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("did become active")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
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
    
}
