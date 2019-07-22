//
//  CoreDataManager.swift
//  Five
//
//  Created by Mark Wong on 17/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    fileprivate var context: NSManagedObjectContext? = nil

    fileprivate init() {
        //This prevents others from using the default '()' initializer for this class.
        loadContext()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FiveModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func loadContext() {
        self.context = persistentContainer.viewContext
    }
    
    func saveContext() {
        guard let context = context else { return }
        if (context.hasChanges) {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchContext() -> NSManagedObjectContext? {
        guard context != nil else { return nil }
        return context
    }
    
    func fetchDayEntity(forDate date: Date) -> Day? {
        let context = self.context
        let dayRequest: NSFetchRequest<Day> = Day.fetchRequest()
        dayRequest.returnsObjectsAsFaults = false
        dayRequest.predicate = NSPredicate(format: "date == %@", date as NSDate)
        
        do {
            let fetchedResults = try context?.fetch(dayRequest)
            return fetchedResults?.first
        } catch let error as NSError {
            print("Day entity could not be fetched \(error)")
            return nil
        }
    }
    
    func printTodaysRecordIn<E: NSManagedObject>(entity: E.Type) {
        let today = Calendar.current.today()
        guard let day: Day = self.fetchDayEntity(forDate: today) else {
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
    
    func countTasks(forDate date: Date) -> Int {
        let day = fetchDayEntity(forDate: Calendar.current.today())
        let count = day?.dayToTask?.count ?? 0
        return count
    }
    
    func deleteAllRecordsIn<E: NSManagedObject>(entity: E.Type) -> Bool {
        
        if (self.doesEntityExist(forDate: Calendar.current.today())) {
            do {
                let fr = E.fetchRequest()
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fr)
                try self.fetchContext()?.execute(deleteRequest)
                try self.fetchContext()?.save()
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
}
