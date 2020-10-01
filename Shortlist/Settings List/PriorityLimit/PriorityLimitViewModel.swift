//
//  PriorityLimitViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 7/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

// MARK: - View Model
class PriorityLimitViewModel: NSObject {
	
	private var persistentContainer: PersistentContainer
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<PriorityLimitSection, PriorityLimitItem>! = nil
	
	init(persistentContainer: PersistentContainer) {
		self.persistentContainer = persistentContainer
		super.init()
	}
	
	// MARK: - Table View
	// prepare snapshot
	func prepareSnapshot() -> [PriorityLimitItem] {
		var dataSource: [PriorityLimitItem] = []
		
		// high - max limit is 3
		for i in 1...3 {
			dataSource.append(contentsOf: [PriorityLimitItem(title: "\(i)", limit: i, section: .highPriority)])
		}
		
		// medium and low max limit is 5 for each level
		for i in 1...5 {
			dataSource.append(contentsOf: [PriorityLimitItem(title: "\(i)", limit: i, section: .mediumPriority)])
			dataSource.append(contentsOf: [PriorityLimitItem(title: "\(i)", limit: i, section: .lowPriority)])
		}
		return dataSource
	}
	
	// configure diffable data source
	func configureDiffableDataSource(collectionView: UICollectionView) {
		diffableDataSource = UICollectionViewDiffableDataSource<PriorityLimitSection, PriorityLimitItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellRegistration(), for: indexPath, item: item)
			return cell
		}
		
		// Supplementary Views
		let headerRegistration = UICollectionView.SupplementaryRegistration
		<BaseCollectionViewListHeader>(elementKind: "PriorityHeaderId") {
			(supplementaryView, string, indexPath) in
			if let section = PriorityLimitSection(rawValue: indexPath.section) {
				supplementaryView.updateLabel(with: "\(section.value)")
			}
			supplementaryView.backgroundColor = .clear
		}
		
		diffableDataSource.supplementaryViewProvider = { (view, kind, index) in
			switch TaskOptionsViewController.CollectionListConstants.init(rawValue: kind) {
				case .header:
					return collectionView.dequeueConfiguredReusableSupplementary(using:headerRegistration, for: index)
				default:
					return collectionView.dequeueConfiguredReusableSupplementary(using:headerRegistration, for: index)
			}
		}
		
		// BUG: using this apply method refreshes the collectionview twice. however using the method with the animating differences won't allow for dynamic heights
		diffableDataSource.apply(configureSnapshot())
	}
	
	// configure diffable datasource snapshot
	func configureSnapshot() -> NSDiffableDataSourceSnapshot<PriorityLimitSection, PriorityLimitItem> {
		var diffableDataSource = NSDiffableDataSourceSnapshot<PriorityLimitSection, PriorityLimitItem>()
		diffableDataSource.appendSections(PriorityLimitSection.allCases)

		for item in prepareSnapshot() {
			diffableDataSource.appendItems([item], toSection: item.section)
		}
		
		return diffableDataSource
	}
	
	// configure cell
	private func configureCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, PriorityLimitItem> {
		let cellConfig = UICollectionView.CellRegistration<UICollectionViewListCell, PriorityLimitItem> { (cell, indexPath, item) in
			// configure cell
			var content: UIListContentConfiguration = cell.defaultContentConfiguration()
			content.text = item.title
			content.textProperties.font = ThemeV2.CellProperties.PrimaryFont
			
			// pre select limits
			if let section = PriorityLimitSection(rawValue: indexPath.section) {
				switch section {
					case .highPriority:
						if (self.currentHighPriorityTaskLimit() == indexPath.item) {
							cell.accessories = [.checkmark()]
						}
					case .mediumPriority:
						if (self.currentMediumPriorityTaskLimit() == indexPath.item) {
							cell.accessories = [.checkmark()]
						}
					case .lowPriority:
						if (self.currentLowPriorityTaskLimit() == indexPath.item) {
							cell.accessories = [.checkmark()]
						}
				}
			}
			
			cell.contentConfiguration = content

		}
		return cellConfig
	}
	
	// MARK: - Priority Level limit
	func currentHighPriorityTaskLimit() -> Int {
		if let taskLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.HighPriorityLimit) {
			return taskLimit
		}
		return 3
	}
	
	func currentMediumPriorityTaskLimit() -> Int {
		if let taskLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.MediumPriorityLimit) {
			return taskLimit
		}
		return 3
	}
	
	func currentLowPriorityTaskLimit() -> Int {
		if let taskLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.LowPriorityLimit) {
			return taskLimit
		}
		return 3
	}
	
	// MARK: - Update model
	func updateDayObject(persistentContainer: PersistentContainer) {
		let today = persistentContainer.fetchDayEntity(forDate: Calendar.current.today()) as! Day
		today.dayToStats?.highPriority = Int64(currentHighPriorityTaskLimit())
		today.dayToStats?.lowPriority = Int64(currentLowPriorityTaskLimit())
		today.dayToStats?.mediumPriority = Int64(currentMediumPriorityTaskLimit())
	}
	
	func updateKeychain(indexPath: IndexPath) {
		let row = indexPath.row
		
		if let section = PriorityLimitSection(rawValue: indexPath.section) {
			switch section {
				case .highPriority:
					KeychainWrapper.standard.set(row, forKey: SettingsKeyChainKeys.HighPriorityLimit)
				case .mediumPriority:
					KeychainWrapper.standard.set(row, forKey: SettingsKeyChainKeys.MediumPriorityLimit)
				case .lowPriority:
					KeychainWrapper.standard.set(row, forKey: SettingsKeyChainKeys.LowPriorityLimit)
			}
		}
	}
}
