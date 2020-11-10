//
//  WhatsNewViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 7/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

struct WhatsNew {
	typealias Version = String
	typealias FeatureDescription = String
	typealias Feature = String
	var version: String
	var build: String
	var updates: [Version : [Feature : FeatureDescription]]
	var brief: String
	var fixes: [Version : [FeatureDescription]]
}

enum FeatureSection: Int, CaseIterable {
	case newFeatures = 0
	case fixes
	
	var image: String {
		switch self {
			case .newFeatures:
				return "plus.circle.fill"
			case .fixes:
				return "bandage.fill"
		}
	}
}

struct FeatureItem: Hashable {
	var title: String
	var description: String
	var section: FeatureSection
	var image: String
}

class WhatsNewViewModel: NSObject {
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<FeatureSection, FeatureItem>! = nil
			
	private var changeLog: ChangeLog? = nil
	
	override init() {
		super.init()
		readJSONVersionFile()
	}
	
	private func readJSONVersionFile() {
		if let version = AppMetaData.version {
			if let url = Bundle.main.url(forResource: "version\(version).json", withExtension: nil) {
				
				if let data = try? Data(contentsOf: url) {
					do {
						let decoder = JSONDecoder()
						let dateFormatter = DateFormatter()
						dateFormatter.dateFormat = "dd-MM-yyyy"
						decoder.dateDecodingStrategy = .formatted(dateFormatter)
						let changes = try decoder.decode(ChangeLog.self, from: data)
						self.changeLog = changes
					} catch (let error) {
//						print("\(error)")
					}
				}
			} else {
				
				if let data = try? Data(contentsOf: Bundle.main.url(forResource: "default", withExtension: nil)!) {
					do {
						let decoder = JSONDecoder()
						let dateFormatter = DateFormatter()
						dateFormatter.dateFormat = "dd-MM-yyyy"
						decoder.dateDecodingStrategy = .formatted(dateFormatter)
						let changes = try decoder.decode(ChangeLog.self, from: data)
						self.changeLog = changes
					} catch (let error) {
//						print("\(error)")
					}
				}
			}
		}
	}
	
	private func prepareDataSource() -> ChangeLog {
		if let version = AppMetaData.version {
			if version == self.changeLog?.version ?? "1.0" {
				if let changeLog = self.changeLog {
					return changeLog
				}
			} else {
				return ChangeLog(version: "1.0", date: Date(), versionDescription: "Unknown Change Log", feature: [])
			}
		}
		return ChangeLog(version: "1.0", date: Date(), versionDescription: "Unknown Change Log", feature: [])
	}
}


// table view methods
extension WhatsNewViewModel {
	// configure diffable data source
	func configureDiffableDataSource(collectionView: UICollectionView) {
		diffableDataSource = UICollectionViewDiffableDataSource<FeatureSection, FeatureItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellRegistration(), for: indexPath, item: item)
			return cell
		}
		
		//Supplementary Views
		let headerRegistration = UICollectionView.SupplementaryRegistration
		<SupplementaryViewHeader>(elementKind: WhatsNewViewController.header) { [weak self]
			(supplementaryView, string, indexPath) in
			guard let self = self else { return }
			
			if indexPath.section == FeatureSection.newFeatures.rawValue {
				if AppMetaData.version != nil {
					supplementaryView.updateBriefLabel(with: self.changeLog?.versionDescription ?? "Unknown Description")
					supplementaryView.updateTitleLabel(with: "What's New!")
				}
			}
			
			supplementaryView.backgroundColor = .clear
		}
		
		diffableDataSource.supplementaryViewProvider = { (view, kind, index) in
			return collectionView.dequeueConfiguredReusableSupplementary(
					using:headerRegistration, for: index)
		}
		
		// BUG: using this apply method refreshes the collectionview twice. however using the method with the animating differences won't allow for dynamic heights
		diffableDataSource.apply(configureSnapshot())
	}
	
	// configure cell
	private func configureCellRegistration() -> UICollectionView.CellRegistration<WhatsNewCell, FeatureItem> {
		let cellConfig = UICollectionView.CellRegistration<WhatsNewCell, FeatureItem> { (cell, indexPath, item) in
			// configure cell
			cell.configureCell(with: item)
		}
		return cellConfig
	}
	
	// configure diffable datasource snapshot
	func configureSnapshot() -> NSDiffableDataSourceSnapshot<FeatureSection, FeatureItem> {
		var diffableDataSource = NSDiffableDataSourceSnapshot<FeatureSection, FeatureItem>()
		diffableDataSource.appendSections(FeatureSection.allCases)
		let dataSource = prepareDataSource()
		
		for item in prepareSnapshot(changeLog: dataSource) {
			diffableDataSource.appendItems([item], toSection: item.section)
		}
		
		return diffableDataSource
	}
	
	func prepareSnapshot(changeLog: ChangeLog) -> [FeatureItem] {
		
		// Features
		let features: [Feature] = changeLog.feature
		
		var array: [FeatureItem] = []
		for feature in features {
			if let section = FeatureSection.init(rawValue: feature.type) {
				array.append(FeatureItem(title: feature.title, description: feature.description, section: section, image: section.image))
			}
		}
		return array
	}
}



