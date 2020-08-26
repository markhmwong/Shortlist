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
	}
	
	enum DataSection: Int {
		case delete
	}
	
	enum ConcealSection: Int {
		case redact
	}
	
	enum ReminderSection: Int {
		case alarm
		case allday
	}
}

struct TaskOptionsItem: Hashable {
	var name: String
	var icon: String
	var section: TaskOptionsSection
	var isAllDay: Bool?
	var isRedacted: Bool?
	var delete: Bool?
	// store data
}

class TaskOptionsViewModel: NSObject {
	// Datasource Reference
	var reminderItem: TaskOptionsItem?
	
	var calendarItem: TaskOptionsItem?
	
	// Model
	private var data: TaskItem
	
	private var persistentContainer: PersistentContainer
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<TaskOptionsSection, TaskOptionsItem>! = nil
	
	init(data: TaskItem, persistentContainer: PersistentContainer) {
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
		diffableDataSource.apply(configureSnapshot(), animatingDifferences: false) {
			
		}
	}
	
	private func prepareDataSource() -> [TaskOptionsItem] {
		let titleItem = TaskOptionsItem(name: "Name", icon: "pencil.circle.fill", section: .content)
		let notesItem = TaskOptionsItem(name: "Notes", icon: "doc.append.fill", section: .content)
		reminderItem = TaskOptionsItem(name: "Alarm", icon: "deskclock.fill", section: .reminder)
		let allDayItem = TaskOptionsItem(name: "All Day", icon: "sunrise.fill", section: .reminder, isAllDay: false) // update data
		let redactedItem = TaskOptionsItem(name: "Redact", icon: "eye.slash.fill", section: .redact, isRedacted: false) // update data
		
		let deleteItem = TaskOptionsItem(name: "Delete Task", icon: "xmark.bin.fill", section: .data, delete: false)

		guard let reminderItem = reminderItem else { return [] }
		return [titleItem, notesItem, reminderItem, allDayItem, redactedItem, deleteItem]
	}
	
	// MARK: - Register Cell
	private func configureCellRegistration() -> UICollectionView.CellRegistration<BaseTableListCell<TaskOptionsItem>, TaskOptionsItem> {
		let cellConfig = UICollectionView.CellRegistration<BaseTableListCell<TaskOptionsItem>, TaskOptionsItem> { (cell, indexPath, item) in

			// configure cell
			var content: UIListContentConfiguration = cell.defaultContentConfiguration()
			content.text = item.name
			let config = UIImage.SymbolConfiguration(pointSize: 16)
			content.image = UIImage(systemName: "\(item.icon)", withConfiguration: config)
			cell.contentConfiguration = content
			
			if item.delete != nil {
				cell.accessories = []
			} else {
				cell.accessories = [.disclosureIndicator()]
			}
			self.addSwitch(with: item, in: cell)
			
		}
		return cellConfig
	}
	
	private func addSwitch(with item: TaskOptionsItem, in cell: BaseTableListCell<TaskOptionsItem>) {
		if let isAllDay = item.isAllDay {
			let enableAllDayAlarm = UISwitch()
			enableAllDayAlarm.addTarget(self, action: #selector(handleAllDay), for: .valueChanged)
			enableAllDayAlarm.isOn = isAllDay // to do update with data
			let customAccessory = UICellAccessory.CustomViewConfiguration(
			  customView: enableAllDayAlarm,
			  placement: .trailing(displayed: .always))
			cell.accessories = [.customView(configuration: customAccessory)]
		}
		
		if let isRedacted = item.isRedacted {
			let enableAllDayAlarm = UISwitch()
			enableAllDayAlarm.addTarget(self, action: #selector(handleRedacted), for: .valueChanged)
			enableAllDayAlarm.isOn = isRedacted // to do update with data
			let customAccessory = UICellAccessory.CustomViewConfiguration(
			  customView: enableAllDayAlarm,
			  placement: .trailing(displayed: .always))
			cell.accessories = [.customView(configuration: customAccessory)]
		}
	}
	
	private func configureCalendarCellRegistration() -> UICollectionView.CellRegistration<CalendarCell, TaskOptionsItem> {
		let cellConfig = UICollectionView.CellRegistration<CalendarCell, TaskOptionsItem> { (cell, indexPath, item) in

		}
		return cellConfig
	}
	
	@objc private func handleAllDay() {
		print("Handle all day")
	}
	
	@objc private func handleRedacted() {
		print("Handle all day")
	}
}

// MARK: - Task Options Cells

// MARK: - Standard Collection View list Cell
class TaskOptionCell: BaseTableListCell<TaskOptionsItem> {
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		setupCellViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


