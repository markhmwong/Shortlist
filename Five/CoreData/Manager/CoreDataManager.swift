//
//  CoreDataManager.swift
//  Five
//
//  Created by Mark Wong on 17/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    public typealias CoreDataManagerCompletion = () -> ()
    
    private let completion: CoreDataManagerCompletion
    
    private let modelName: String
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // Fetch Model URL
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        // Initialize Managed Object Model
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        return NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    }()
    
    public private(set) lazy var privateManagedObjectContext: NSManagedObjectContext = {
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    public private(set) lazy var mainManagedObjectContext: NSManagedObjectContext = {
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.parent = self.privateManagedObjectContext
        
        return managedObjectContext
    }()
    
    init(modelName: String, completion: @escaping CoreDataManagerCompletion) {
        self.modelName = modelName
        self.completion = completion
        setupCoreDataStack()
    }
    
    private func setupCoreDataStack() {
        // Fetch Persistent Store Coordinator
        guard let persistentStoreCoordinator = mainManagedObjectContext.persistentStoreCoordinator else {
            fatalError("Unable to Set Up Core Data Stack")
        }
        
        DispatchQueue.global().async {
            // Add Persistent Store
            self.addPersistentStore(to: persistentStoreCoordinator)
            
            // Invoke Completion On Main Queue
            DispatchQueue.main.async { self.completion() }
        }
    }
    
    private func addPersistentStore(to persistentStoreCoordinator: NSPersistentStoreCoordinator) {
        // Helpers
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        
        // URL Documents Directory
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // URL Persistent Store
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption : true,
                NSInferMappingModelAutomaticallyOption : true
            ]
            
            // Add Persistent Store
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: options)
            
        } catch {
            fatalError("Unable to Add Persistent Store")
        }
    }
    
    public func saveChanges() {
        mainManagedObjectContext.performAndWait {
            do {
                if self.mainManagedObjectContext.hasChanges {
                    try self.mainManagedObjectContext.save()
                }
            } catch {
                print("Unable to Save Changes of Main Managed Object Context")
                print("\(error), \(error.localizedDescription)")
            }
        }
        
        privateManagedObjectContext.perform {
            do {
                if self.privateManagedObjectContext.hasChanges {
                    try self.privateManagedObjectContext.save()
                }
            } catch {
                print("Unable to Save Changes of Private Managed Object Context")
                print("\(error), \(error.localizedDescription)")
            }
        }
    }
    
    public func privateChildManagedObjectContext() -> NSManagedObjectContext {
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.parent = mainManagedObjectContext
        
        return managedObjectContext
    }
}

// Helper Functions
extension CoreDataManager {
    func countTasks(forDate date: Date) -> Int {
        let day = fetchDayEntity(forDate: Calendar.current.today()) as? Day
        let count = day?.dayToTask?.count ?? 0
        return count
    }
    
    func deleteAllRecordsIn<E: NSManagedObject>(entity: E.Type) -> Bool {
        
        if (self.doesEntityExist(forDate: Calendar.current.today())) {
            do {
                let fr = E.fetchRequest()
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fr)
                try self.mainManagedObjectContext.execute(deleteRequest)
                saveChanges()
                //                try self.fetchContext()?.execute(deleteRequest)
                //                try self.fetchContext()?.save()
                return true
            } catch let error as NSError {
                print("Trouble deleting all records in entity: \(error)")
                return false
            }
        } else {
            print("Nothing to delete")
            return false
        }
    }
    
    func printTodaysRecordIn<E: NSManagedObject>(entity: E.Type) {
        let today = Calendar.current.today()
        guard let day: Day = self.fetchDayEntity(forDate: today) as? Day else {
            print("Cannot print entity")
            return
        }
        for task in day.dayToTask as! Set<Task> {
            print(task.name!)
            print(task.complete)
        }
    }
    
    func doesEntityExist(forDate date: Date) -> Bool {
        guard self.fetchDayEntity(forDate: date) != nil else {
            print("Nothing In Entity")
            return false
        }
        return true
    }
    
    func fetchDayEntity(forDate date: Date) -> NSManagedObject? {
        let context = self.mainManagedObjectContext
        let dayRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Day")
        dayRequest.returnsObjectsAsFaults = false
        dayRequest.predicate = NSPredicate(format: "createdAt == %@", date as NSDate)
        
        do {
            let fetchedResults = try context.fetch(dayRequest)
            return fetchedResults.first as? NSManagedObject
        } catch let error as NSError {
            print("Day entity could not be fetched \(error)")
            return nil
        }
    }
}
