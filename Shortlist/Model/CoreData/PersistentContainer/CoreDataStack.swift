//
//  PersistenceCoordinator.swift
//  Five
//
//  Created by Mark Wong on 29/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataStack: NSObject {

    /// singleton instance
    public static let shared: CoreDataStack = CoreDataStack()

    /// create queue
	public let dataQueue: DispatchQueue = DispatchQueue(label: "com.whizbang.shortlist.queue.coredata", qos: .utility)

    // MARK: - Core Data stack

	static let appGroupIdentifier = "group.com.whizbang.Five"

	public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ShortlistModel")

        // Store in the shared App Group container so WidgetKit and other extensions can read it.
        if let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: CoreDataStack.appGroupIdentifier) {
            let storeURL = groupURL.appendingPathComponent("ShortlistModel.sqlite")
            let description = NSPersistentStoreDescription(url: storeURL)
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    public var moc: NSManagedObjectContext? = nil


	public override init() {
        super.init()
        self.moc = self.persistentContainer.viewContext
    }
    // MARK: - Core Data Saving support

	public func saveContext () {
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
    
	public func deleteAllObjects() {
        guard let moc = moc else {
            print("Unable to delete item")
            return
        }
        
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SLTask")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            try moc.execute(deleteRequest)
            try moc.save()
        } catch let err {
            print("Failed to delete item \(err)")
            return
        }
    }
    
	public func fetchTodaysItems() -> [SLTask] {
        guard let moc = moc else { return [] }
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let startOfTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday)!
        do {
            let fetchRequest: NSFetchRequest<SLTask> = SLTask.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "createdAt >= %@ AND createdAt < %@",
                startOfToday as NSDate, startOfTomorrow as NSDate
            )
            let items = try moc.fetch(fetchRequest)
            return items
        } catch {
            print("Failed to fetch items: \(error)")
            return []
        }
    }
    
	public func fetchNumberOfItems() -> Int16 {
        return Int16(fetchTodaysItems().count)
    }
    
	public func delete(objectId item: NSManagedObjectID) {
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

// MARK: Settings
// Settings methods
extension CoreDataStack {

    public func createInitialSettingsModel() {
        guard let moc = moc else { return }

        let settings = SLSettings(context: moc)
        settings.taskLimit = 3
        
        self.saveContext()
    }
    
    public func fetchSettingsModel() -> Bool {
        guard let moc = moc else { return false }

        let fetchRequest: NSFetchRequest<SLSettings> = SLSettings.fetchRequest()
        fetchRequest.fetchLimit = 1

        do {
            let settings = try moc.fetch(fetchRequest)
            return settings.isEmpty ? false : true
        } catch {
            print("Failed to fetch SLSettings: \(error)")
            return false
        }
    }

	/// Get the total daily task limit
    public func fetchSettingsTaskLimit() -> Int16 {
        guard let moc = moc else { return 0 }
        let property = "taskLimit"
        do {
            let fetchRequest: NSFetchRequest<SLSettings> = SLSettings.fetchRequest()
            fetchRequest.propertiesToFetch = [property]
            let limit = try moc.fetch(fetchRequest)
            if let result = limit.first {
                let taskLimit = result.taskLimit
                return taskLimit
            }
        } catch {
            print("Failed to fetch items: \(error)")
            return 0
        }
        return 0
    }

	/// Save the daily task limit
    public func saveDailyTaskLimit(_ value: Int16) {
        guard let moc = moc else { return }
        do {
            let fetchRequest: NSFetchRequest<SLSettings> = SLSettings.fetchRequest()
//            fetchRequest.fetchLimit = 1
            let limit = try moc.fetch(fetchRequest)
            if let settings = limit.first {
                settings.taskLimit = value
            }
        } catch {
            print("Failed to apply new task limit: \(error)")
            return
        }
    }
}
