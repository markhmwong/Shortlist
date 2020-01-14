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
//		print("\(idNum), \(idNum.numberToWord())")
		task.name = "An interesting task"
        task.complete = false
        task.carryOver = false
        task.category = "A memorable category (optional)"
		task.isNew = true
        task.priority = Int16(idNum)
        task.id = Int16(idNum)
        day.addToDayToTask(task)
    }
	
	// deprecated
	func createTask(toEntity day: Day, context: NSManagedObjectContext, idNum: Int, taskName: String, categoryName: String, createdAt: Date, reminderDate: Date) {
		let task: Task = Task(context: context)
		task.name = taskName
		task.complete = false
		task.carryOver = false
		task.category = categoryName
		task.isNew = false 
		task.priority = Int16(idNum)
		task.id = Int16(idNum)
		task.createdAt = createdAt as NSDate
		task.reminder = reminderDate as NSDate
		day.addToDayToTask(task)
	}
    
	func createCategoryInBackLog(_ name: String, context: NSManagedObjectContext) {
		let category: BackLog = BackLog(context: context)
		category.name = name
	}
	
//	func createCategoryInCategoryList(_ name: String, context: NSManagedObjectContext) {
//		let category: CategoryList = CategoryList(context: context)
//		category.name = name
//	}
	
	// is this in use?
	func saveTaskToCategory(forName categoryName: String, task: BigListTask) {
		let categoryRequest: NSFetchRequest<BackLog> = BackLog.fetchRequest()
		categoryRequest.returnsObjectsAsFaults = false
		categoryRequest.predicate = NSPredicate(format: "name == %@", categoryName)
		
        do {
			let fetchedResults = try viewContext.fetch(categoryRequest)
			if let categoryObject = fetchedResults.first {
				// revisit 4/1/19
//				categoryObject.addToBigListToBigListTask(<#T##value: BigListTask##BigListTask#>)
			}
			return
        } catch let error as NSError {
            print("Category entity could not be fetched \(error)")
            return
        }
	}
	
	func deleteCategory(forName categoryName: String) -> Bool {
		let categoryRequest: NSFetchRequest<BackLog> = BackLog.fetchRequest()
		categoryRequest.returnsObjectsAsFaults = false
		categoryRequest.predicate = NSPredicate(format: "name == %@", categoryName)
		
        do {
			let fetchedResults = try viewContext.fetch(categoryRequest)
			if let categoryObject = fetchedResults.first {
				viewContext.delete(categoryObject)
				return true
			}
			return false
        } catch let error as NSError {
            print("Category entity could not be fetched \(error)")
            return false
        }
	}
	
	func doesExistInCategoryList(_ name: String) -> Bool {
		let context = viewContext
		let categoryRequest: NSFetchRequest<CategoryList> = CategoryList.fetchRequest()
		categoryRequest.returnsObjectsAsFaults = false
		categoryRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let fetchedResults = try context.fetch(categoryRequest)
			if fetchedResults.first != nil {
				return true
			} else {
				return false
			}
        } catch let error as NSError {
            print("Day entity could not be fetched \(error)")
            return false
        }
	}
	
	
	func categoryExistsInBackLog(_ name: String) -> Bool {
		let context = viewContext
		let categoryRequest: NSFetchRequest<BackLog> = BackLog.fetchRequest()
		categoryRequest.returnsObjectsAsFaults = false
		categoryRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let fetchedResults = try context.fetch(categoryRequest)
			if fetchedResults.first != nil {
				return true
			} else {
				return false
			}
        } catch let error as NSError {
            print("Day entity could not be fetched \(error)")
            return false
        }
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
	
    func fetchBigListCategory(forDate categoryName: String) -> BackLog? {
        let context = viewContext
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "BackLog")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "name == %@", categoryName)
        
        do {
            let fetchedResults = try context.fetch(request)
            return fetchedResults.first as? BackLog
        } catch let error as NSError {
            print("Big List Category entity could not be fetched \(error)")
            return nil
        }
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
		do {
			let fr = E.fetchRequest()
			let deleteRequest = NSBatchDeleteRequest(fetchRequest: fr)
			try viewContext.execute(deleteRequest)
			saveContext(backgroundContext: nil)
			return true
		} catch let error {
			print("Trouble deleting all records in entity: \(error)")
			return false
		}
    }
	
	func fetchStatEntity() -> Stats? {
		// id = 0. Should only be one stat entity, must use id of 0
        let context = viewContext
		let id = 0
		let request: NSFetchRequest<Stats> = Stats.fetchRequest()
		request.returnsObjectsAsFaults = false
		request.predicate = NSPredicate(format: "id == %i", id)
		
		do {
            let fetchedResults = try context.fetch(request)
			return fetchedResults.first
        } catch let error as NSError {
            print("Stats entity could not be fetched \(error)")
            return nil
        }
	}
}
