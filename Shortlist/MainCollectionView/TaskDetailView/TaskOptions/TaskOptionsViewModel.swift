//
//  TaskOptionsViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 19/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

enum TaskOptionsType: Int, CaseIterable {
	case name = 0
	case photo
	case note
	case alarm
	case redact
	case delete
}

// Table View Setup
enum TaskOptionsSection: Int, CaseIterable {
	case content
	case notes
	case reminder
	case redact
	case data
	
	var value: String {
		switch self {
			case .content:
				return "Content"
			case .notes:
				return "Notes"
			case .reminder:
				return "Reminder"
			case .redact:
				return "Conceal"
			case .data:
				return "Data"
		}
	}
	
	var footerValue: String {
		switch self {
			case .content:
				return "Edit written content such as the task name and notes related to the task."
			case .notes:
				return "Edit written notes attached to this task."
			case .reminder:
				return "Set a task reminder or an all day reminder, to set a 2 hour reminder which repeatedly appears as a notification on the lock screen for the entire day."
			case .redact:
				return "If you wish to hide a sensitive task, use Redact to censor the task from the main screen. This conceals the name and features of the task until authorized by the user to reveal itself. To access the task, you must use FaceID or a Passcode."
			case .data:
				return "Removing data is permanant and cannot be reversed."
		}
	}
	
	enum ContentSection: Int {
		case name
		case photo
	}
	
	enum NotesSection: Int {
		case notes
	}
	
	enum DataSection: Int {
		case delete
	}
	
	enum ConcealSection: Int {
		case redactStyle
	}
	
	enum ReminderSection: Int {
		case alarm
	}
}


// MARK: - Task Options Item
struct TaskOptionsItem: Hashable, BaseDescriptiveItem {
	static func == (lhs: TaskOptionsItem, rhs: TaskOptionsItem) -> Bool {
		return lhs.id == rhs.id
	}
	
	var id: UUID = UUID()
	var title: String
	var description: String
	var image: String
	var section: TaskOptionsSection
	var isAllDay: Bool?
	var isRedacted: Bool?
	var delete: Bool?
	var redactStyle: RedactState?
	var type: TaskOptionsType
	// store data
}

class TaskOptionsViewModel: NSObject {
	
	// Core Data
	private lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
		// Create Fetch Request
		let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
		
		// Configure Fetch Request
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
		fetchRequest.predicate = NSPredicate(format: "createdAt == %@", argumentArray: [data.createdAt ?? Date()])
		
		// Create Fetched Results Controller
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
		
		// Configure Fetched Results Controller
		fetchedResultsController.delegate = self
		return fetchedResultsController
	}()
	
	private let noteLimit = 4
	
	// Datasource Reference
	var reminderItem: TaskOptionsItem?
	
	var calendarItem: TaskOptionsItem?
	
	// Model
	var data: Task
	
	var persistentContainer: PersistentContainer
	
	private var mainFetcher: MainFetcher<Task>! = nil
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<TaskOptionsSection, TaskOptionsItem>! = nil
	
	init(data: Task, persistentContainer: PersistentContainer) {
		self.persistentContainer = persistentContainer
		self.data = data
		// reminder, notes etc
		super.init()
		self.mainFetcher = MainFetcher(controller: fetchedResultsController)
		mainFetcher.initFetchedObjects()
	}

	// MARK: - Diffable Datasource
	func configureSnapshot() {
		guard let diffableDataSource = diffableDataSource else { return }
		
		var snapshot = NSDiffableDataSourceSnapshot<TaskOptionsSection, TaskOptionsItem>()
		snapshot.appendSections(TaskOptionsSection.allCases)
		
		let data = prepareDataSource()
		
		for d in data {
			snapshot.appendItems([d], toSection: d.section)
		}

		// BUG: using this apply method refreshes the collectionview twice. however using the method with the animating differences won't allow for dynamic heights
		diffableDataSource.apply(snapshot, animatingDifferences: false) { }
	}

	func configureDataSource(collectionView: UICollectionView) {
		
		// Setup datasource and cells
		diffableDataSource = UICollectionViewDiffableDataSource<TaskOptionsSection, TaskOptionsItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewListCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellRegistration(), for: indexPath, item: item)
			return cell
		}
		
		// Setup Supplementary Views
		let headerRegistration = UICollectionView.SupplementaryRegistration
		<BaseCollectionViewListHeader>(elementKind: TaskOptionsViewController.CollectionListConstants.header.rawValue) {
			(supplementaryView, string, indexPath) in
			if let section = TaskOptionsSection(rawValue: indexPath.section) {
				supplementaryView.updateLabel(with: "\(section.value)")
			}
			supplementaryView.backgroundColor = .clear
		}
		
		let footerRegistration = UICollectionView.SupplementaryRegistration
		<BaseCollectionViewListFooter>(elementKind: TaskOptionsViewController.CollectionListConstants.footer.rawValue) {
			(supplementaryView, string, indexPath) in
			if let section = TaskOptionsSection(rawValue: indexPath.section) {
				supplementaryView.updateLabel(with: "\(section.footerValue)")
			}
			supplementaryView.backgroundColor = .clear
		}
		
		diffableDataSource.supplementaryViewProvider = { (view, kind, index) in
			switch TaskOptionsViewController.CollectionListConstants.init(rawValue: kind) {
				case .header:
					return collectionView.dequeueConfiguredReusableSupplementary(using:headerRegistration, for: index)
				case .footer:
					return collectionView.dequeueConfiguredReusableSupplementary(using:footerRegistration, for: index)
				default:
					return collectionView.dequeueConfiguredReusableSupplementary(using:headerRegistration, for: index)
			}
		}
		configureSnapshot()
	}
	
//	MARK: - Prepare Datasource
	private func prepareDataSource() -> [TaskOptionsItem] {

		var taskOptionsItems: [TaskOptionsItem] = []
		
		let titleItem = TaskOptionsItem(title: "Name", description: "Edit the name", image: Icons.notes.sfSymbolString, section: .content, type: .name)
		let photoItem = TaskOptionsItem(title: "Add from Photo Library", description: "Attach a photo from your library", image: Icons.photo.sfSymbolString, section: .content, type: .photo)
		

		reminderItem = TaskOptionsItem(title: "Alarm", description: "Edit the alarm time to set a notification to remind you", image: Icons.reminder.sfSymbolString, section: .reminder, type: .alarm)
		let redactedStyleItem = TaskOptionsItem(title: "Redact", description: "Censor the task", image: Icons.redact.sfSymbolString, section: .redact, redactStyle: RedactState.censor, type: .redact) // update data
		let deleteItem = TaskOptionsItem(title: "Delete Task", description: "Remove task from today's list", image: Icons.delete.sfSymbolString, section: .data, delete: true, type: .delete)
		
		// Handle notes and its' items
		if let task = mainFetcher.fetchRequestedObjects()?.first {
			if let notes = task.taskToNotes {
				
				// No notes
				if notes.count == 0 {
					taskOptionsItems.append(TaskOptionsItem(title: "Add a Note", description: "Edit the notes", image: Icons.notes.sfSymbolString, section: .notes, type: .note))
				} else {
					// Contains notes
					for (index, item) in notes.array.enumerated() {
						// existing note
						let note = item as! TaskNote
						taskOptionsItems.append(TaskOptionsItem(title: "\(note.note ?? "Add a Note")", description: "", image: "\(index)\(Icons.noteNumber.sfSymbolString)", section: .notes, type: .note))
						
						// add the extra item to allow the user to add a note
						if (index == notes.array.count - 1) {
							taskOptionsItems.append(TaskOptionsItem(title: "Add a Note", description: "Include additional notes to flesh our the task.", image: "plus.square.fill.on.square.fill", section: .notes, type: .note))
						}
					}
				}
			} else {
				// nil notes in case we haven't initialised the relationship between Task and Notes
				taskOptionsItems.append(TaskOptionsItem(title: "Add a Note", description: "Edit the notes", image: Icons.notes.sfSymbolString, section: .notes, type: .note))
			}
		}
		guard let reminderItem = reminderItem else { return [] }
		
		taskOptionsItems.append(contentsOf: [titleItem, photoItem, reminderItem, redactedStyleItem, deleteItem])
		
		return taskOptionsItems
	}
	
	// MARK: - Register Cell
	private func configureCellRegistration() -> UICollectionView.CellRegistration<TaskOptionsCell, TaskOptionsItem> {
		let cellConfig = UICollectionView.CellRegistration<TaskOptionsCell, TaskOptionsItem> { (cell, indexPath, item) in
			// setup cell views and text from item
			cell.configureCell(with: item)
		}
		return cellConfig
	}

	
	private func configureCalendarCellRegistration() -> UICollectionView.CellRegistration<AlarmCell, TaskOptionsItem> {
		let cellConfig = UICollectionView.CellRegistration<AlarmCell, TaskOptionsItem> { (cell, indexPath, item) in
		}
		return cellConfig
	}
}

/*

	MARK: - Fetched Results Controller Delegate

*/
extension TaskOptionsViewModel: NSFetchedResultsControllerDelegate {
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
		configureSnapshot()
	}
}
