//
//  PersistenceCoordinator.swift
//  Five
//
//  Created by Mark Wong on 29/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation
import CoreData


class PersistentContainer: NSPersistentContainer {
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
    func fetchAllTasksByYear(forYear year: Int16) -> [Day] {
        let context = viewContext
        let dayRequest: NSFetchRequest<Day> = Day.fetchRequest()
        dayRequest.returnsObjectsAsFaults = false
        dayRequest.predicate = NSPredicate(format: "year == %i", year)
        do {
            let fetchedResults = try context.fetch(dayRequest)
            return fetchedResults
            //            return fetchedResults.first
        } catch let error as NSError {
            print("Day entity could not be fetched \(error)")
            return []
        }
    }
    
    func fetchAllTasksByMonth(forMonth month: Int16, year: Int16) -> [Day] {
        let context = viewContext
        let dayRequest: NSFetchRequest<Day> = Day.fetchRequest()
        dayRequest.returnsObjectsAsFaults = false
        dayRequest.predicate = NSPredicate(format: "month == %i AND year == %i", month, year)
        do {
            let fetchedResults = try context.fetch(dayRequest)
            return fetchedResults
        } catch let error as NSError {
            print("Day entity could not be fetched \(error)")
            return []
        }
    }
    
    func fetchRangeOfDays(from startDate: Date, to endDate: Date = Calendar.current.today()) -> [Day] {
        let context = viewContext
        let dayRequest: NSFetchRequest<Day> = Day.fetchRequest()
        dayRequest.returnsObjectsAsFaults = false
        dayRequest.predicate = NSPredicate(format: "createdAt >= %@ AND createdAt <= %@", startDate as NSDate, endDate as NSDate)
        do {
            let fetchedResults = try context.fetch(dayRequest)
            return fetchedResults
            
        } catch let error as NSError {
            print("Day entity could not be fetched \(error)")
            return []
        }
    }
    
    func fetchAllTasksByWeek(forWeek beginning: Date, today: Date) -> [Day] {
        let context = viewContext
        let dayRequest: NSFetchRequest<Day> = Day.fetchRequest()
        dayRequest.returnsObjectsAsFaults = false
        dayRequest.predicate = NSPredicate(format: "createdAt >= %@ AND createdAt <= %@", beginning as NSDate, today as NSDate)
        do {
            let fetchedResults = try context.fetch(dayRequest)
            return fetchedResults

        } catch let error as NSError {
            print("Day entity could not be fetched \(error)")
            return []
        }
    }
    
    // Fetches Day Object by date
    func fetchDayManagedObject(forDate date: Date) -> Day? {
        let context = viewContext
        let dayRequest: NSFetchRequest<Day> = Day.fetchRequest()
        
        dayRequest.returnsObjectsAsFaults = false
        dayRequest.predicate = NSPredicate(format: "createdAt == %@", date as NSDate)
        
        do {
            let fetchedResults = try context.fetch(dayRequest)
            return fetchedResults.first
        } catch let error as NSError {
            print("Day entity could not be fetched \(error)")
            return nil
        }
    }
    
    func createSampleTask(toEntity day: Day, context: NSManagedObjectContext, idNum: Int) {
        let task: Task = Task(context: context)
        task.name = idNum.numberToWord()
        task.complete = false
        task.carryOver = false
        task.category = 0 // to do categories by string or dynamically adjusted
        task.priority = Int16(idNum)
        task.id = Int16(idNum)
        day.addToDayToTask(task)
    }
    
    func doesEntityExist(forDate date: Date) -> Bool {
        guard fetchDayEntity(forDate: date) != nil else {
            print("Nothing In Entity")
            return false
        }
        return true
    }
    
    func countTasks(forDate date: Date) -> Int {
        let day = fetchDayEntity(forDate: Calendar.current.today()) as? Day
        let count = day?.dayToTask?.count ?? 0
        return count
    }
    
    func fetchDayEntity(forDate date: Date) -> NSManagedObject? {
        let context = viewContext
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
    
    func deleteAllRecordsIn<E: NSManagedObject>(entity: E.Type) -> Bool {
        
        if (self.doesEntityExist(forDate: Calendar.current.today())) {
            do {
                let fr = E.fetchRequest()
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fr)
                try viewContext.execute(deleteRequest)
                saveContext(backgroundContext: nil)
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
