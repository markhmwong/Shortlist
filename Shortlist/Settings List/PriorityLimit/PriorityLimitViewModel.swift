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
	
    private var dataSource: [PriorityLimitItem] = []
    
	var persistentContainer: PersistentContainer
	
    private var snapshot: NSDiffableDataSourceSnapshot<PriorityLimitSection, PriorityLimitItem>! = nil

	private var diffableDataSource: UICollectionViewDiffableDataSource<PriorityLimitSection, PriorityLimitItem>! = nil
	
    var data: Day
    
    private var mainFetcher: MainFetcher<Day>! = nil

    init(persistentContainer: PersistentContainer, data: Day) {
        self.data = data
		self.persistentContainer = persistentContainer
		super.init()
	}
	
	// MARK: - Table View
	// prepare snapshot
	func prepareDatasource() {
        dataSource.removeAll()
        // datasource
        for i in 0...2 {
            let state = data.highPriorityLimit == i
            dataSource.append(PriorityLimitItem(title: "\(i)", limit: i, section: .highPriority, state: state))
        }
        for i in 0...4 {
            let state = data.mediumPriorityLimit == i
            dataSource.append(PriorityLimitItem(title: "\(i)", limit: i, section: .mediumPriority, state: state))
        }
        for i in 0...4 {
            let state = data.lowPriorityLimit == i
            dataSource.append(PriorityLimitItem(title: "\(i)", limit: i, section: .lowPriority, state: state))
        }
	}
	
	// configure diffable data source
    func configureDiffableDataSource(collectionView: UICollectionView, resultsController: MainFetcher<Day>) {
        mainFetcher = resultsController
        let cellRegistration = self.configureCellRegistration()
		diffableDataSource = UICollectionViewDiffableDataSource<PriorityLimitSection, PriorityLimitItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
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
        updateSnapshot()
	}
	
	// configure diffable datasource snapshot
	func updateSnapshot() {
        guard let d = diffableDataSource else { return }
        prepareDatasource()
        self.snapshot = NSDiffableDataSourceSnapshot<PriorityLimitSection, PriorityLimitItem>()
        self.snapshot.appendSections(PriorityLimitSection.allCases)
        for item in self.dataSource {
            self.snapshot.appendItems([item], toSection: item.section)
		}
        d.apply(snapshot)
	}
	
	// configure cell
	private func configureCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, PriorityLimitItem> {
		let cellConfig = UICollectionView.CellRegistration<UICollectionViewListCell, PriorityLimitItem> { (cell, indexPath, item) in
			// configure cell
            var content: UIListContentConfiguration = cell.defaultContentConfiguration()
			content.text = item.title
			content.textProperties.font = ThemeV2.CellProperties.PrimaryFont
            cell.contentConfiguration = content
            
            if item.state {
                cell.accessories = [.checkmark()]
            } else {
                cell.accessories = []
            }
		}
		return cellConfig
	}
	
	// MARK: - Priority Level limit
	func currentHighPriorityTaskLimit() -> Int {
		if let taskLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.HighPriorityLimit) {
			return taskLimit
		}
        return Int(Priority.high.rawValue)
	}
	
	func currentMediumPriorityTaskLimit() -> Int {
		if let taskLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.MediumPriorityLimit) {
			return taskLimit
		}
		return Int(Priority.high.rawValue)
	}
	
	func currentLowPriorityTaskLimit() -> Int {
		if let taskLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.LowPriorityLimit) {
			return taskLimit
		}
		return Int(Priority.high.rawValue)
	}
	
	// MARK: - Update model
	func updatePriorityLimit(indexPath: IndexPath) {
		let row = indexPath.row
        let date = Date()
        data.updatedAt = date as NSDate
		if let section = PriorityLimitSection(rawValue: indexPath.section) {
            let row = Int16(row)
			switch section {
				case .highPriority:
                    data.highPriorityLimit = row
				case .mediumPriority:
                    data.mediumPriorityLimit = row
				case .lowPriority:
                    data.lowPriorityLimit = row
            }
		}
        persistentContainer.saveContext()
	}
}
