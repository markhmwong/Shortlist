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
	
	var delegate: TaskCreationNotesViewController? = nil
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<TaskCreationNotesSection, TaskCreationNotesItem>! = nil
	
	private var diffableRedactDataSource: UICollectionViewDiffableDataSource<TaskCreationNotesSection, TaskCreationRedactItem>! = nil

	
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

enum TaskCreationNotesSection: Int, CaseIterable {
	case main
}

struct TaskCreationNotesItem: Hashable {
	var id: UUID = UUID()
	var description: String
	var date: Date = Date()
	var noteNumber: Int
}

struct TaskCreationRedactItem: Hashable {
	var id: UUID = UUID()
	var name: String
	var style: RedactStyle
}

extension TaskCreationViewModel {
	
	// MARK: - Diffable Datasource Redact
	func configureRedactDataSource(collectionView: UICollectionView) {
	
		diffableRedactDataSource = UICollectionViewDiffableDataSource<TaskCreationNotesSection, TaskCreationRedactItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewListCell? in
			
			let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureRedactCellRegistration(), for: indexPath, item: item)
			return cell
		}
		
		configureRedactSnapshot()
	}
	
	
	private func configureRedactSnapshot() {
		guard let diffableDataSource = diffableRedactDataSource else { return }
		
		var snapshot = NSDiffableDataSourceSnapshot<TaskCreationNotesSection, TaskCreationRedactItem>()
		snapshot.appendSections(TaskCreationNotesSection.allCases)
		
		let data = prepareRedactDataSource()
		
		for d in data {
			snapshot.appendItems([d], toSection: TaskCreationNotesSection.main)
		}

		// BUG: using this apply method refreshes the collectionview twice. however using the method with the animating differences won't allow for dynamic heights
		diffableDataSource.apply(snapshot, animatingDifferences: false) { }
	}
	
	// MARK: - Prep Redact
	private func prepareRedactDataSource() -> [TaskCreationRedactItem] {
		var taskOptionsItems: [TaskCreationRedactItem] = []
		
		for i in 0..<3 {
			let redact = RedactStyle.init(rawValue: i) ?? .none
			let item = TaskCreationRedactItem(id: UUID(), name: redact.stringValue, style: redact)
			taskOptionsItems.append(item)
		}

		return taskOptionsItems
	}
	

	
	// MARK: - Register Cell
	private func configureRedactCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, TaskCreationRedactItem> {
		let cellConfig = UICollectionView.CellRegistration<UICollectionViewListCell, TaskCreationRedactItem> { (cell, indexPath, item) in
			// setup cell views and text from item
			var config = cell.defaultContentConfiguration()
			config.text = "\(item.name)"
			config.textProperties.color = ThemeV2.TextColor.DefaultColor
			cell.contentConfiguration = config
			
		}
		return cellConfig
	}
}

extension TaskCreationViewModel {
	/******
		CollectionView methods required for Notes View Controller
	********/

	// MARK: - Diffable Datasource
	private func configureSnapshot() {
		guard let diffableDataSource = diffableDataSource else { return }
		
		var snapshot = NSDiffableDataSourceSnapshot<TaskCreationNotesSection, TaskCreationNotesItem>()
		snapshot.appendSections(TaskCreationNotesSection.allCases)
		
		let data = prepareDataSource()
		
		for d in data {
			snapshot.appendItems([d], toSection: TaskCreationNotesSection.main)
		}

		// BUG: using this apply method refreshes the collectionview twice. however using the method with the animating differences won't allow for dynamic heights
		diffableDataSource.apply(snapshot, animatingDifferences: false) { }
	}
	

	
	// MARK: - Prep data Notes
	private func prepareDataSource() -> [TaskCreationNotesItem] {
		var taskOptionsItems: [TaskCreationNotesItem] = []
		
		let itemOne = TaskCreationNotesItem(id: UUID(), description: "Little details matter..", date: Date(), noteNumber: 1)
		taskOptionsItems.append(itemOne)
		return taskOptionsItems
	}
	
	func addNoteItem() -> UIAlertController? {
		var currentSnapshot = diffableDataSource.snapshot()
		if currentSnapshot.numberOfItems <= 4 {
			let num = currentSnapshot.numberOfItems + 1
			let newNote = TaskCreationNotesItem(id: UUID(), description: "Little details matter..", date: Date(), noteNumber: num)
			currentSnapshot.appendItems([newNote], toSection: .main)
					
			diffableDataSource.apply(currentSnapshot)
			return nil
		} else {
			let ac = UIAlertController(title: "Maximum allowed notes reach", message: "Try to keep notes precise and succinct", preferredStyle: .alert)
			let alertAction = UIAlertAction(title: "Done", style: .default) { (action) in
				
			}
			ac.addAction(alertAction)
			return ac
		}
	}
	
	// viewcontroller entry begins here
	func configureDataSource(collectionView: UICollectionView) {
		diffableDataSource = UICollectionViewDiffableDataSource<TaskCreationNotesSection, TaskCreationNotesItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewListCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellRegistration(), for: indexPath, item: item)
			return cell
		}
		
		configureSnapshot()
	}
	
	// MARK: - Register Cell
	private func configureCellRegistration() -> UICollectionView.CellRegistration<TaskCreationNotesListCell, TaskCreationNotesItem> {
		let cellConfig = UICollectionView.CellRegistration<TaskCreationNotesListCell, TaskCreationNotesItem> { (cell, indexPath, item) in
			// setup cell views and text from item
			cell.configureCell(with: item)
			cell.delegate = self.delegate
		}
		return cellConfig
	}
	
	// MARK: - Photo functions
	func saveImage(imageData: UIImage) {
		// scale photo
		
		let thumbnail = UIImage().scalePhotoToThumbnail(image: imageData, width: Double(imageData.size.width), height: Double(imageData.size.height))
		
		// convert to jpeg
		guard let i = imageData.jpegData(compressionQuality: 1.0), let thumbnailData = thumbnail.jpegData(compressionQuality: 0.5) else {
			// handle failed conversion
			print("jpg error")
			return
		}
		
		// save process
		persistentContainer.savePhoto(data: task, fullRes: i, thumbnail: thumbnailData)
		persistentContainer.saveContext()
	}
}
