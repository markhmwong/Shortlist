//
//  PersistenceCoordinator.swift
//  Five
//
//  Created by Mark Wong on 29/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack: NSObject {
    
    /// singleton instance
    static let shared: CoreDataStack = CoreDataStack()
    
    /// create queue
    let dataQueue: DispatchQueue = DispatchQueue(label: "com.whizbang.shortlist.queue.coredata", qos: .utility)
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ShortlistModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public var moc: NSManagedObjectContext? = nil


    override init() {
        super.init()
        self.moc = self.persistentContainer.viewContext
    }
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteAllObjects() {
        guard let moc = moc else {
            print("Unable to delete item")
            return
        }
        
        
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SLTask")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            
            let deleteResult = try moc.execute(deleteRequest)
            try moc.save()
            moc.refreshAllObjects()
        } catch let err {
            print("Failed to delete item \(err)")
            return
        }
    }
    
    func fetchItem() {
        
    }
    
    func fetchTodaysItems() -> [SLTask] {
        guard let moc = moc else { return [] }
        
        do {
            let fetchRequest: NSFetchRequest<SLTask> = SLTask.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "taskToStatus.name == %@", TaskStatus.Incomplete.rawValue as CVarArg)
            let items = try moc.fetch(fetchRequest)
            return items
        } catch {
            print("Failed to fetch items: \(error)")
            return []
        }
    }
    
    func delete(objectId item: NSManagedObjectID) {
        guard let moc = moc else {
            print("Unable to delete item")
            return
        }
        
        
        do {
            let task = try moc.existingObject(with: item)
            moc.delete(task)
            try moc.save()
        } catch let err {
            print("Failed to delete item \(err)")
            return
        }
        
    }
}
