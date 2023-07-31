//
//  EmptyTaskMessageGenerator.swift
//  Shortlist
//
//  Created by Mark Wong on 28/7/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import Foundation
import CoreAudioTypes

class EmptyTaskMessageGenerator: NSObject {
    
    enum Message: String, CaseIterable {
        case e0
        case e1
        case e2
        case e3
        
        var message: String {
            switch self {
            case .e0:
                return "No tasks today.\nLet's get started!"
            case .e1:
                return "All you need to do is start with one task.\nLet's go!"
            case .e2:
                return "Today will be the day.\nAdd a new task."
            case .e3:
                return "Add a new task. It can be as easy as making your bed."
            }
        }
    }
    
    override init() {
        super.init()
    }
    
    func generate() -> String {
        let rng = Int.random(in: Message.allCases.indices)
        return Message.allCases[rng].message
    }
    
}
