//
//  PendingOpertaions.swift
//  Five
//
//  Created by Mark Wong on 27/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

class PendingOperations {
    
    lazy var coreDataProgress: [Operation] = []
    lazy var coreDataQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "CoreDataQueue"
        return queue
    }()
    
}
