//
//  AlarmViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 25/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class AlarmViewModel: NSObject {
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<AlarmSection, AlarmItem>! = nil
	
	private var dataSource: [AlarmItem] = []
	
	// need it for the task's date
	private var data: Task
	
	private var taskReminder: TaskReminder?
	
	private var reminder: Date?

	var presetType: PresetType = .minutes5 {
		didSet {
			assignPresetTime(type:presetType)
		}
	}
	
	private var persistentContainer: PersistentContainer
	
	private var mainFetcher: MainFetcher<Task>! = nil
	
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
	
	var isAllDay: Bool = false
	
	var isEnabled: Bool = false // reminder is enabled
	
	init(data: Task, persistentContainer: PersistentContainer) {
		self.data = data
		self.persistentContainer = persistentContainer
		super.init()
		self.mainFetcher = MainFetcher(controller: fetchedResultsController)
		mainFetcher.initFetchedObjects()
		
		taskReminder = mainFetcher.fetchRequestedObjects()?.first?.taskToReminder ?? nil
		self.isEnabled = taskReminder?.reminder != nil ? true : false
		self.reminder = taskReminder?.reminder
	}
	
	// MARK: - Register Cell
	private func configureCellRegistration() -> UICollectionView.CellRegistration<AlarmCell, AlarmItem> {
		let cellConfig = UICollectionView.CellRegistration<AlarmCell, AlarmItem> { (cell, indexPath, item) in
			cell.configureCell(with: item)
			
			cell.isEnabledClosure = { (buttonState) in
				self.isEnabled = buttonState
				self.resetReminder(buttonState: self.isEnabled)
				self.updateSnapshot()
			}
			
			cell.isAllDayClosure = { (buttonState) in
				self.isAllDay = buttonState
				self.allDay()
				self.updateSnapshot()
			}
			
			cell.dateChange = { (date) in
				self.updateReminder(date: date)
			}
		}
		return cellConfig
	}
	
	private func configureCellRegistrationForHeader() -> UICollectionView.CellRegistration<AlarmHeaderCell, AlarmItem> {
	
		let cellConfig = UICollectionView.CellRegistration<AlarmHeaderCell, AlarmItem> { (cell, indexPath, item) in
			cell.configureCell(with: item)
			
			
		}
		return cellConfig
	
	
	}
	
	// MARK: - Diffable Datasource
	func configureSnapshot() {
		guard let diffableDataSource = diffableDataSource else { return }
		var snapshot = NSDiffableDataSourceSnapshot<AlarmSection, AlarmItem>()
		snapshot.appendSections(AlarmSection.allCases)
		
		dataSource.removeAll()
		prepareDataSource()
		
		for d in dataSource {
			snapshot.appendItems([d], toSection: d.section)
		}
		
		diffableDataSource.apply(snapshot, animatingDifferences: false) { }
	}
	
	//MARK: - Update Snapshot
	func updateSnapshot() {
		var currentSnapshot = NSDiffableDataSourceSnapshot<AlarmSection, AlarmItem>()
		let filteredItems = dataSource.filter { (item) -> Bool in
			if isEnabled {
				return true // return all items
			} else {
				return item.section == .Enabled
			}
		}
		
		// this won't work inside filteredItems
		// Shows and hides the items of the table view
		if isEnabled {
			currentSnapshot.appendSections(AlarmSection.allCases)
		} else {
			currentSnapshot.appendSections([.Enabled])
		}
		
		for item in filteredItems {
			currentSnapshot.appendItems([ item ], toSection: item.section)
		}

		diffableDataSource?.apply(currentSnapshot)
	}
	
	// MARK: - Configure DataSource
	func configureDataSource(collectionView: UICollectionView) {
		diffableDataSource = UICollectionViewDiffableDataSource<AlarmSection, AlarmItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewListCell? in
			
			if let section = AlarmSection.init(rawValue: indexPath.section) {
				
				switch section {
					case .Reminder:
						let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellRegistrationForHeader(), for: indexPath, item: item)
						return cell
					default:
						let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellRegistration(), for: indexPath, item: item)
						return cell
				}
				
			} else {
				return nil
			}
		}
		
		let headerRegistration = UICollectionView.SupplementaryRegistration<BaseCollectionViewListHeader>(elementKind: AlarmViewController.AlarmViewSupplementaryIds.headerId.rawValue) { (supplementaryView, string, indexPath) in
			if let section = AlarmSection(rawValue: indexPath.section) {
				supplementaryView.updateLabel(with: section.headerTitle)
			}
			supplementaryView.backgroundColor = .clear
		}
		
		let footerRegistration = UICollectionView.SupplementaryRegistration<BaseCollectionViewListFooter>(elementKind: AlarmViewController.AlarmViewSupplementaryIds.footerId.rawValue) { (supplementaryView, string, indexPath) in
			if let section = AlarmSection(rawValue: indexPath.section) {
				supplementaryView.updateLabel(with: section.footerDescription)
			}
			supplementaryView.backgroundColor = .clear
		}
		
		diffableDataSource.supplementaryViewProvider = { (_ , kind, index) in
			switch AlarmViewController.AlarmViewSupplementaryIds.init(rawValue: kind) {
				case .headerId:
					return collectionView.dequeueConfiguredReusableSupplementary(using:headerRegistration, for: index)
				case .footerId:
					return collectionView.dequeueConfiguredReusableSupplementary(using:footerRegistration, for: index)
				default:
					return collectionView.dequeueConfiguredReusableSupplementary(using:headerRegistration, for: index)
			}
		}
		
		if data.taskToReminder?.reminder != nil {
			isEnabled = true
		} else {
			isEnabled = false
		}
		
		prepareDataSource()
		updateSnapshot()
		// BUG: using this apply method refreshes the collectionview twice. however using the method with the animating differences won't allow for dynamic heights
	}
	
	// MARK: - Prepare DataSource
	private func prepareDataSource() {

		let reminder = taskReminder
		
		let allDayState = reminder?.isAllDay ?? false
		// Header
		
		let headerTime = reminder?.reminder?.timeToStringInHrMin()
		
		let alarmHeader: AlarmItem = AlarmItem(title: headerTime ?? "00:00", section: .Reminder, timeValue: 0, isAllDay: allDayState, isCustom: reminder?.isCustom ?? false, isPreset: reminder?.isPreset ?? false, presetType: nil, reminder: Date())
		
		let enabled = AlarmItem(title: "Enabled", section: .Enabled, timeValue: 0, isAllDay: nil, isCustom: nil, isPreset: nil, presetType: nil, reminder: reminder?.reminder)
		let allDay = AlarmItem(title: "All Day", section: .AllDay, timeValue: 0, isAllDay: allDayState)
		let custom = AlarmItem(title: "", section: .Custom, timeValue: 0, isCustom: reminder?.isCustom ?? false)
		dataSource.append(contentsOf: [ enabled, alarmHeader, allDay, custom ])
		
		let interval: Int = 5
		let seconds: Int = 60
		for i in 1..<PresetType.allCases.count {
			let time: Int = seconds * interval * i
			var item = AlarmItem(title: "\(i * interval) mins", section: .Preset, timeValue: time, isPreset: reminder?.isPreset ?? false, presetType: nil)

			if (reminder?.presetType ?? -1 == i) {
				item.presetType = Int(reminder?.presetType ?? -1)
			}
			dataSource.append(item)
		}
	}
	
	/*
	
		MARK: - Toggle Methods
	
	*/
	
	private func updateReminder(date: Date) {
		// reset reminder to clear the preset, custom and all day values
		let reminder = taskReminder
		reminder?.resetReminder() //required to reset - as we are only allowed one type of alarm to be set
		
		// set custom reminder
		reminder?.isCustom = true
		reminder?.reminder = date
		data.taskToReminder = taskReminder
		persistentContainer.saveContext()
	}
	
	private func allDay() {
		self.resetReminder(buttonState: self.isAllDay)
	}
	
	func assignPresetTime(type: PresetType) {
		
		// assign preset type and save to core data
		if let reminder = taskReminder {
			reminder.resetReminder()
			
			reminder.isPreset = true
			let dateAfter = Date().addingTimeInterval(TimeInterval(type.typeToSeconds()))
			reminder.reminder = dateAfter
			reminder.presetType = Int16(type.rawValue)
			data.taskToReminder = reminder
			persistentContainer.saveContext()
		}
	}
	
	func setCustomTime(date: Date) {
		//
	}
	
	func resetReminder(buttonState: Bool) {
		let reminder = taskReminder
		if buttonState {
			// reminder is enabled
			reminder?.reminder = Date()
		} else {
			// reminder is disabled
			reminder?.resetReminder()
		}
		reminder?.isPreset = false
		reminder?.presetType = -1 // means non selected
		data.taskToReminder = reminder // this triggers fetched results
		persistentContainer.saveContext()
	}
	
	func clearAllReminders() {
		
	}
}

/*

	MARK: - Fetched Results Controller Delegate

*/
extension AlarmViewModel: NSFetchedResultsControllerDelegate {
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
		configureSnapshot()
	}
}
