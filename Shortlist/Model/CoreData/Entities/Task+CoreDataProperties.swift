//
//  Task+CoreDataProperties.swift
//  
//
//  Created by Mark Wong on 30/9/20.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var carryOver: Bool
    @NSManaged public var category: String?
    @NSManaged public var complete: Bool
    @NSManaged public var createdAt: Date?
    @NSManaged public var details: String?
    @NSManaged public var id: Int16
    @NSManaged public var isNew: Bool
    @NSManaged public var name: String?
    @NSManaged public var priority: Int16
    @NSManaged public var redactStyle: Int16
    @NSManaged public var reminder: Date?
    @NSManaged public var reminderId: String?
    @NSManaged public var reminderState: Bool
    @NSManaged public var taskToBackLog: BackLog?
    @NSManaged public var taskToDay: Day?
    @NSManaged public var taskToNotes: NSOrderedSet?
    @NSManaged public var taskToPhotos: NSOrderedSet?
    @NSManaged public var taskToReminder: TaskReminder?
	@NSManaged public var updateAt: Date?

}

// MARK: Generated accessors for taskToNotes
extension Task {

    @objc(insertObject:inTaskToNotesAtIndex:)
    @NSManaged public func insertIntoTaskToNotes(_ value: TaskNote, at idx: Int)

    @objc(removeObjectFromTaskToNotesAtIndex:)
    @NSManaged public func removeFromTaskToNotes(at idx: Int)

    @objc(insertTaskToNotes:atIndexes:)
    @NSManaged public func insertIntoTaskToNotes(_ values: [TaskNote], at indexes: NSIndexSet)

    @objc(removeTaskToNotesAtIndexes:)
    @NSManaged public func removeFromTaskToNotes(at indexes: NSIndexSet)

    @objc(replaceObjectInTaskToNotesAtIndex:withObject:)
    @NSManaged public func replaceTaskToNotes(at idx: Int, with value: TaskNote)

    @objc(replaceTaskToNotesAtIndexes:withTaskToNotes:)
    @NSManaged public func replaceTaskToNotes(at indexes: NSIndexSet, with values: [TaskNote])

    @objc(addTaskToNotesObject:)
    @NSManaged public func addToTaskToNotes(_ value: TaskNote)

    @objc(removeTaskToNotesObject:)
    @NSManaged public func removeFromTaskToNotes(_ value: TaskNote)

    @objc(addTaskToNotes:)
    @NSManaged public func addToTaskToNotes(_ values: NSOrderedSet)

    @objc(removeTaskToNotes:)
    @NSManaged public func removeFromTaskToNotes(_ values: NSOrderedSet)

}

// MARK: Generated accessors for taskToPhotos
extension Task {

    @objc(insertObject:inTaskToPhotosAtIndex:)
    @NSManaged public func insertIntoTaskToPhotos(_ value: TaskPhotos, at idx: Int)

    @objc(removeObjectFromTaskToPhotosAtIndex:)
    @NSManaged public func removeFromTaskToPhotos(at idx: Int)

    @objc(insertTaskToPhotos:atIndexes:)
    @NSManaged public func insertIntoTaskToPhotos(_ values: [TaskPhotos], at indexes: NSIndexSet)

    @objc(removeTaskToPhotosAtIndexes:)
    @NSManaged public func removeFromTaskToPhotos(at indexes: NSIndexSet)

    @objc(replaceObjectInTaskToPhotosAtIndex:withObject:)
    @NSManaged public func replaceTaskToPhotos(at idx: Int, with value: TaskPhotos)

    @objc(replaceTaskToPhotosAtIndexes:withTaskToPhotos:)
    @NSManaged public func replaceTaskToPhotos(at indexes: NSIndexSet, with values: [TaskPhotos])

    @objc(addTaskToPhotosObject:)
    @NSManaged public func addToTaskToPhotos(_ value: TaskPhotos)

    @objc(removeTaskToPhotosObject:)
    @NSManaged public func removeFromTaskToPhotos(_ value: TaskPhotos)

    @objc(addTaskToPhotos:)
    @NSManaged public func addToTaskToPhotos(_ values: NSOrderedSet)

    @objc(removeTaskToPhotos:)
    @NSManaged public func removeFromTaskToPhotos(_ values: NSOrderedSet)

}
