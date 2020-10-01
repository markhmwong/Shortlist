//
//  AlarmViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 25/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class AlarmViewModel: NSObject {
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<AlarmSection, AlarmItem>! = nil
	
	private var dataSource: [AlarmItem] = []
	
	private var data: Task
	
	init(data: Task) {
		self.data = data
		super.init()
	}
	
	// MARK: - Register Cell
	private func configureCellRegistration() -> UICollectionView.CellRegistration<AlarmCell, AlarmItem> {
		let cellConfig = UICollectionView.CellRegistration<AlarmCell, AlarmItem> { (cell, indexPath, item) in
			cell.configureCell(with: item)
		}
		return cellConfig
	}
	
	// MARK: - Diffable Datasource
	func configureSnapshot() -> NSDiffableDataSourceSnapshot<AlarmSection, AlarmItem> {
		var snapshot = NSDiffableDataSourceSnapshot<AlarmSection, AlarmItem>()
		snapshot.appendSections(AlarmSection.allCases)
		
		prepareDataSource()
		
		for d in dataSource {
			snapshot.appendItems([d], toSection: d.section)
		}
		
		return snapshot
	}
	
	func updateSnapshot(allDay: Bool) {
		var currentSnapshot = NSDiffableDataSourceSnapshot<AlarmSection, AlarmItem>()
		let filteredItems = dataSource.filter { (item) -> Bool in
			if !allDay {
				return true // return all
			} else {
				return item.section == .AllDay
			}
		}
		
		// this won't work inside filteredItems
		if !allDay {
			currentSnapshot.appendSections(AlarmSection.allCases)
		} else {
			currentSnapshot.appendSections([.AllDay])
		}
		
		for item in filteredItems {
			currentSnapshot.appendItems([ item ], toSection: item.section)
		}

		diffableDataSource.apply(currentSnapshot)
	}
	
	func configureDataSource(collectionView: UICollectionView) {
		diffableDataSource = UICollectionViewDiffableDataSource<AlarmSection, AlarmItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewListCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellRegistration(), for: indexPath, item: item)
			
			cell.allDayClosure = { (buttonState) in
				self.updateSnapshot(allDay: buttonState)
			}
			return cell
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
		
		let reminder = data.taskToReminder
		let allDayState = reminder?.isAllDay ?? false
		
		prepareDataSource()
		updateSnapshot(allDay: allDayState)
		// BUG: using this apply method refreshes the collectionview twice. however using the method with the animating differences won't allow for dynamic heights
	}
	
	private func prepareDataSource() {
		
		let reminder = data.taskToReminder
		let allDayState = reminder?.isAllDay ?? false
		let allDay = AlarmItem(title: "All Day", section: .AllDay, timeValue: 0, isAllDay: allDayState)
		let custom = AlarmItem(title: "", section: .Custom, timeValue: 0.0, isCustom: true)
		
		dataSource.append(contentsOf: [ allDay, custom ])
		
		let interval = 5
		let seconds: Float = 60
		for i in 1..<13 {
			let time: Float = seconds * Float(interval) * Float(i)
			let item = AlarmItem(title: "\(i * interval) mins", section: .Preset, timeValue: time)
			dataSource.append(item)
		}

	}
}
