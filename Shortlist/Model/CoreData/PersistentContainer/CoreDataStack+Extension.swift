//
//  CoreDataStack+Extension.swift
//  Shortlist
//
//  Created by Mark Wong on 16/6/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import Foundation

extension CoreDataStack {
    
    func createMockItems() {
        for i in 0...5 {
            let item = SLTask(context: moc!)
            item.name = "Clean storm drain \(i)"
            item.createdAt = Date()
            item.carryOver = false
            item.complete = false
            item.id = UUID()
            self.saveContext()
        }
    }
    
}
