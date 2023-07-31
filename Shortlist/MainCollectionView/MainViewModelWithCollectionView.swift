//
//  MainViewModelWithCollectionView.swift
//  Shortlist
//
//  Created by Mark Wong on 23/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class MainViewModelWithCollectionView: NSObject {
	
	// change to cache
	private var tempDataSource: [TaskItem] = []
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<Priority, Task>! = nil
	
	private var mainFetcher: MainFetcher<Day>! = nil
	
    var day: Day? = nil
    
    private var collectionView: UICollectionView! = nil
    
    private var addTaskButton: UIButton! = nil
    
	override init() {
		super.init()
		prepareDataSource()
	}
	
	// MARK: - Configure Datasource
    func configureDataSource(collectionView: UICollectionView, resultsController: MainFetcher<Day>, button: UIButton) {
        self.addTaskButton = button
		mainFetcher = resultsController
        self.collectionView = collectionView
        
        let cellRego = self.configureCellRegistration()
		diffableDataSource = UICollectionViewDiffableDataSource<Priority, Task>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(using: cellRego, for: indexPath, item: item)
            cell.configureCell(with: item)
			return cell
		}
		diffableDataSource.apply(configureSnapshot())
	}
	
	// MARK: - Snapshot
	private func configureSnapshot() -> NSDiffableDataSourceSnapshot<Priority, Task> {
		var snapshot = NSDiffableDataSourceSnapshot<Priority, Task>()
		snapshot.appendSections([.high, .medium, .low])
        self.day = mainFetcher.fetchRequestedObjects()?.first
		
		let tasks = day?.dayToTask?.allObjects as? [Task] ?? []
        taskSizeCheck(tasks)
        
		for (_, task) in tasks.enumerated() {
			snapshot.appendItems([task], toSection: Priority.init(rawValue: task.priority))
		}
		return snapshot
	}
    
    func updateSnapshot() {
        guard let mainFetcher = self.mainFetcher else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Priority, Task>()
        snapshot.appendSections([.high, .medium, .low])
        
        self.day = mainFetcher.fetchRequestedObjects()?.first
        if let day = self.day {
            let tasks = day.dayToTask?.allObjects as? [Task] ?? []
            taskSizeCheck(tasks)
            for (_, task) in tasks.enumerated() {
                snapshot.appendItems([task], toSection: Priority.init(rawValue: task.priority))
            }
            diffableDataSource.apply(snapshot, animatingDifferences: true)
        }
    }
	
	// MARK: - Register
	private func configureCellRegistration() -> UICollectionView.CellRegistration<MainTaskCell, Task> {
		let cellConfig = UICollectionView.CellRegistration<MainTaskCell, Task> { (cell, indexPath, item) in
			cell.configureCell(with: item)
		}
		return cellConfig
	}

	func taskForSelection(indexPath: IndexPath) -> Task {
		guard let item = diffableDataSource.itemIdentifier(for: indexPath) else {
			return Task()
		}
		return item
	}
    
    func taskSizeCheck(_ tasks: [Task]) {
        if tasks.isEmpty {
            let gen = EmptyTaskMessageGenerator()
            self.collectionView.backgroundView = EmptyCollectionView(message: gen.generate())
            animateAddTaskButton()
        } else {
            // removes animation and empty collection view
            self.collectionView.backgroundView = nil
            UIView.animate(withDuration: 0.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: [.beginFromCurrentState, .curveLinear, .preferredFramesPerSecond60, .allowUserInteraction], animations: {
                self.addTaskButton.alpha = 1.0
                self.addTaskButton.tintColor = .systemMint
            }, completion: { state in
                //
            })
        }
    }
}

extension MainViewModelWithCollectionView {
    // animate add task button
    // pulses the button
    private func animateAddTaskButton() {
        UIView.animate(withDuration: 2.1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: [.repeat, .curveLinear, .preferredFramesPerSecond60, .allowUserInteraction], animations: {
            self.addTaskButton.alpha = 0.4
            self.addTaskButton.tintColor = .systemMint
        }, completion: { state in
            self.addTaskButton.alpha = 1.0
        })
    }
}

// MOCK Methods
extension MainViewModelWithCollectionView {
	// MARK: - Prepare data source
	func prepareDataSource() {
		tempDataSource = [
//			TaskItem(title: "First Task. Fire Merlin Engine at full capacity. Stress test #1", notes: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially 상쾌한. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum fdsfds dfs fds f.", priority: .high, completionStatus: true, reminder: "Reminder", redaction: RedactComponent(redactStyle: RedactStyle.disclose)),
//			TaskItem(title: "Second Task. A longer title to test 상쾌한 the dynamic height of the Task Collection View Cell. Second Task. A longer title to test the dynamic height of the Task Collection View Cell. ", notes: "Note two", priority: .medium, completionStatus: false, reminder: "Reminder", redaction: RedactComponent(redactStyle: RedactStyle.star)),
//			TaskItem(title: "Third Task", notes: "Note three", priority: .high, completionStatus: false, reminder: "Reminder", redaction: RedactComponent(redactStyle: RedactStyle.highlight)),
//			TaskItem(title: "Fourth Task", notes: "Note four", priority: .low, completionStatus: true, reminder: "Reminder", redaction: RedactComponent(redactStyle: RedactStyle.disclose)),
		]
	}
	
	// MARK: - Core Data Methods
	
	// MOCK DATA
	func addMockData(persistentContainer: PersistentContainer) {
		let today = Date().startOfDay

		var dayObject: Day? = persistentContainer.fetchDayManagedObject(forDate: today)
		if dayObject == nil {
			dayObject = Day(context: persistentContainer.viewContext)
			dayObject?.createNewDay(date: today)
			
			// Task 1
			let task: Task = Task(context: persistentContainer.viewContext)
            task.create(context: persistentContainer.viewContext, taskName: "Task One", categoryName: "Work", createdAt: Date(), reminderDate: Date().addingTimeInterval(600.0), priority: Int(Priority.high.rawValue), redact: RedactStyle.highlight.rawValue, day: dayObject!)
			task.complete = false
			dayObject?.addTask(with: task)
		}

		// Task 2
		let task: Task = Task(context: persistentContainer.viewContext)
		task.create(context: persistentContainer.viewContext, taskName: "Task 4", categoryName: "Recreation", createdAt: Date(), reminderDate: Date().addingTimeInterval(600.0), priority: Int(Priority.high.rawValue), redact: RedactStyle.none.rawValue, day: dayObject!)
		let note: TaskNote = TaskNote(context: persistentContainer.viewContext)
		note.createNotes(note: "Test Note One", isButton: false)
		task.addToTaskToNotes(note)
		task.complete = false

		dayObject?.addTask(with: task)
		
		persistentContainer.saveContext()
		let _ = persistentContainer.deleteAllRecordsIn(entity: Task.self)
	}
	
	func createMockStatisticalData(persistentContainer: PersistentContainer) {
		for day in 1...30 {
			let date = Calendar.current.forSpecifiedDay(value: -day)
			let dayA = persistentContainer.fetchDayManagedObject(forDate: date)
			if dayA?.dayToStats == nil {
				
			}
			if (dayA == nil) {
				// create empty day
				let dayObj = Day(context: persistentContainer.viewContext)
				dayObj.createMockDay(date: date)
				persistentContainer.saveContext()
			}
		}
	}
}
