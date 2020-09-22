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
	
	override init() {
		super.init()
	}
	
	// MARK: - Register Cell
	private func configureCellRegistration() -> UICollectionView.CellRegistration<BaseTableListCell<AlarmItem>, AlarmItem> {
		let cellConfig = UICollectionView.CellRegistration<BaseTableListCell<AlarmItem>, AlarmItem> { (cell, indexPath, item) in

			// configure cell
			var content: UIListContentConfiguration = cell.defaultContentConfiguration()
			content.text = item.name
			cell.contentConfiguration = content

		}
		return cellConfig
	}
	
	private func configureCalendarCellRegistration() -> UICollectionView.CellRegistration<CalendarCell, AlarmItem> {
		let cellConfig = UICollectionView.CellRegistration<CalendarCell, AlarmItem> { (cell, indexPath, item) in
			
		}
		return cellConfig
	}
	
	// MARK: - Diffable Datasource
	func configureSnapshot() -> NSDiffableDataSourceSnapshot<AlarmSection, AlarmItem> {
		var snapshot = NSDiffableDataSourceSnapshot<AlarmSection, AlarmItem>()
		snapshot.appendSections(AlarmSection.allCases)
		
		let data = prepareDataSource()
		
		for d in data {
			snapshot.appendItems([d], toSection: d.section)
		}
		
		return snapshot
	}
	
	func configureDataSource(collectionView: UICollectionView) {
		diffableDataSource = UICollectionViewDiffableDataSource<AlarmSection, AlarmItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewListCell? in
			
			if indexPath.section == AlarmSection.Custom.rawValue {
				let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCalendarCellRegistration(), for: indexPath, item: item)
				return cell
			} else {
				let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellRegistration(), for: indexPath, item: item)
				return cell
			}
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
		diffableDataSource.apply(configureSnapshot())
//		diffableDataSource.apply(configureSnapshot(), animatingDifferences: false) { }
	}
	
	private func prepareDataSource() -> [AlarmItem] {
		let fiveMin = AlarmItem(name: "5 mins", timeValue: 60*5.0, section: .Preset)
		let tenMin = AlarmItem(name: "10 mins", timeValue: 60*10.0, section: .Preset)
		let fifteenMin = AlarmItem(name: "15 mins", timeValue: 60*15.0, section: .Preset)
		let twentyMin = AlarmItem(name: "20 mins", timeValue: 60*20.0, section: .Preset)
		let thirtyMin = AlarmItem(name: "30 mins", timeValue: 60*30.0, section: .Preset)
		let fortyMin = AlarmItem(name: "40 mins", timeValue: 60*40.0, section: .Preset)
		let fiftyMin = AlarmItem(name: "50 mins", timeValue: 60*50.0, section: .Preset)

		let custom = AlarmItem(name: "Custom", timeValue: 0.0, section: .Custom)
		return [fiveMin, tenMin, fifteenMin, twentyMin, thirtyMin, fortyMin, fiftyMin, custom]
	}
}
