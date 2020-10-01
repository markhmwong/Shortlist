//
//  TaskOptionsViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 19/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

// Table View Setup
enum TaskOptionsSection: Int, CaseIterable {
	case content
	case reminder
	case redact
	case data
	
	var value: String {
		switch self {
			case .content:
				return "Content"
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
			case .reminder:
				return "Set a task reminder or an all day reminder, to set a 2 hour reminder which repeatedly appears as a notification on the lock screen for the entire day."
			case .redact:
				return "If you wish to hide a sensitive task, use Redact to censor the task from the main screen. This conceals the name and features of the task until authorized by the user to reveal itself. To access the task, you must use FaceID or a Passcode"
			case .data:
				return "Removing data is permanant and cannot be reversed."
		}
	}
	
	enum ContentSection: Int {
		case name
		case notes
		case photo
	}
	
	enum DataSection: Int {
		case delete
	}
	
	enum ConcealSection: Int {
//		case redact
		case redactStyle
	}
	
	enum ReminderSection: Int {
		case alarm
//		case allday
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
	// store data
}

class TaskOptionsViewModel: NSObject {
	// Datasource Reference
	var reminderItem: TaskOptionsItem?
	
	var calendarItem: TaskOptionsItem?
	
	// Model
	var data: Task
	
	var persistentContainer: PersistentContainer
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<TaskOptionsSection, TaskOptionsItem>! = nil
	
	init(data: Task, persistentContainer: PersistentContainer) {
		self.persistentContainer = persistentContainer
		self.data = data
		// reminder, notes etc
		super.init()
	}

	// MARK: - Diffable Datasource
	func configureSnapshot() -> NSDiffableDataSourceSnapshot<TaskOptionsSection, TaskOptionsItem> {
		var snapshot = NSDiffableDataSourceSnapshot<TaskOptionsSection, TaskOptionsItem>()
		snapshot.appendSections(TaskOptionsSection.allCases)
		
		let data = prepareDataSource()
		
		for d in data {
			snapshot.appendItems([d], toSection: d.section)
		}
		
		return snapshot
	}

	func configureDataSource(collectionView: UICollectionView) {
		diffableDataSource = UICollectionViewDiffableDataSource<TaskOptionsSection, TaskOptionsItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewListCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellRegistration(), for: indexPath, item: item)
			return cell
		}
		
		//Supplementary Views
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
		
		// BUG: using this apply method refreshes the collectionview twice. however using the method with the animating differences won't allow for dynamic heights
//		diffableDataSource.apply(configureSnapshot())
		diffableDataSource.apply(configureSnapshot(), animatingDifferences: false) { }
	}
	
	private func prepareDataSource() -> [TaskOptionsItem] {
		let titleItem = TaskOptionsItem(title: "Name", description: "Edit the name", image: "pencil.circle.fill", section: .content)
		let notesItem = TaskOptionsItem(title: "Notes", description: "Edit the notes", image: "doc.append.fill", section: .content)
		reminderItem = TaskOptionsItem(title: "Alarm", description: "Edit the alarm time to set a notification to remind you", image: "deskclock.fill", section: .reminder)
		let redactedStyleItem = TaskOptionsItem(title: "Redact", description: "Censor the task", image: "eye.slash.fill", section: .redact, redactStyle: RedactState.censor) // update data
		let deleteItem = TaskOptionsItem(title: "Delete Task", description: "Remove task from today's list", image: "xmark.bin.fill", section: .data, delete: true)
		let photoItem = TaskOptionsItem(title: "Add from Photo Library", description: "Attach a photo from your library", image: "photo.fill", section: .content)
		
		guard let reminderItem = reminderItem else { return [] }
		return [titleItem, notesItem, photoItem, reminderItem, redactedStyleItem, deleteItem]
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

