//
//  NewTaskViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 29/11/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

/*

	MARK: - New Task View Model

	One view model passed between the new task guide

*/

class TaskCreationViewModel: NSObject {
	
	var persistentContainer: PersistentContainer
	
	var keyboardSize: CGRect = .zero

	var task: Task
	
	private var mainFetcher: MainFetcher<Task>! = nil
	
	init(persistentContainer: PersistentContainer) {
		self.persistentContainer = persistentContainer
		self.task = Task(context: persistentContainer.viewContext)
		super.init()
	}
	
	func createTask() {
		if let day = persistentContainer.fetchDayEntity(forDate: Calendar.current.today()) as? Day {
			task.create(context: persistentContainer.viewContext, taskName: "", categoryName: "", createdAt: Date(), reminderDate: Date(), priority: 0, redact: 0)
			day.addTask(with: task)
			
			persistentContainer.saveContext()
		}
	}
	
	func assignTitle(taskName: String) {
		task.name = taskName
	}
	
	func assignPriority(priority: Int16) {
		task.priority = priority
	}
}

enum NotesSection: Int, CaseIterable {
	case main
}

//enum NotesType: Int, CaseIterable {
//	case
//}

struct TaskCreationNotesItem {
	var id: UUID = UUID()
	var description: String
	var date: Date = Date()
}

extension TaskCreationViewModel {
	// MARK: - Diffable Datasource
//	func configureSnapshot() {
//		guard let diffableDataSource = diffableDataSource else { return }
//
//		var snapshot = NSDiffableDataSourceSnapshot<TaskOptionsSection, TaskOptionsItem>()
//		snapshot.appendSections(TaskOptionsSection.allCases)
//
//		let data = prepareDataSource()
//
//		for d in data {
//			snapshot.appendItems([d], toSection: d.section)
//		}
//
//		// BUG: using this apply method refreshes the collectionview twice. however using the method with the animating differences won't allow for dynamic heights
//		diffableDataSource.apply(snapshot, animatingDifferences: false) { }
//	}
}
