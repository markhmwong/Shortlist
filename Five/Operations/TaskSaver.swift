//
//  Task.swift
//  CoreDataStack
//
//  Created by Mark Wong on 27/07/2019.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import CoreData
import Foundation

class TaskSaver: Operation {

    // MARK: - Properties
    
    private let managedObjectContext: NSManagedObjectContext
    
    // MARK: - Initialization

    init(managedObjectContext: NSManagedObjectContext) {
        // Set Managed Object Context
        self.managedObjectContext = managedObjectContext
        
        super.init()
    }

    // MARK: - Overrides
    
    override func main() {
        // ...
        
        // Save Changes
        saveChanges()
    }
    
    // MARK: - Helper Methods
    
    private func saveChanges() {
        managedObjectContext.performAndWait {
            do {
                if self.managedObjectContext.hasChanges {
                    try self.managedObjectContext.save()
                }
            } catch {
                print("Unable to Save Changes of Managed Object Context")
                print("\(error), \(error.localizedDescription)")
            }
        }
    }

}
