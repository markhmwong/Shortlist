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
	
	typealias Version = String
	
	private var updates: [Version: [String : String]] = ["" : [:]]
	
	private var brief: [Version: String] = [:]
	
	private var fixes: [Version: [String]] = [:]
	
	override init() {
		super.init()
		prepareWhatsNewFeatures()
	}
	
	private func prepareWhatsNewFeatures() {
		updates["2.0"] = [
			"UI Overhaul" : "With the introduction of iOS 14, parts of the app may seem similar but behind the scenes it uses Apple's latest UI APIs, keeping this app up to date. The UI also includes new touches of neumorphic design and takes advantage of SF Symbols also made by Apple.",
			"Redact Tasks" : "It's now possible to hide and lock sensitive tasks. Various styles are available to reflect your personality. Text are hidden from view and now requires a pin or FaceID to gain access.",
			"Photos" : "Capture an important hand written note or piece of information and add it to your task",
			"Support for multiple languages" : "?",
		]
		// App store
		//You'll have noticed Shortlist has undergone quite a change. Although there are changes, the core of the application has not changed. I still believe that we can increase our productivity while maintaining a balanced life by simply taking 5 - 10 minutes at the beginning of our day to organise the remainder with finite yet important tasks.\n\n
		brief["2.0"] = "Version 2.0 brings a fresh new UI accompanying iOS 14 and its' new APIs offered to developers. Have a look at the new features and fixes below"//\n\nBy bringing this mindset into our lives we can reduce the emotional burden we place on ourselves - we must achieve an incredible amount each day, we must burnout ourselves to exhaustion. This simply isn't true.\n\nI don't have scientific studies or data to back up my claim, but by using what I've done in my life through study and exercise, progression is not without balance and that comes with a well earned break."
		
		fixes["2.0"] = ["All-day reminders would not trigger, now they do.", "Further fixes to behind the scenes warnings in regards to UI."]
	}
	
	private func prepareDataSource() -> WhatsNew {
		if let version = AppMetaData.version, let build = AppMetaData.build {
			return WhatsNew(version: version, build: build, updates: updates, brief: brief[version] ?? "", fixes: fixes)
		}
		return WhatsNew(version: "x.xx", build: "0", updates: ["Unknown" : ["Unknown" : "Unknown"]], brief: "Brief description error.", fixes: [:])
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
				if let version = AppMetaData.version {
					supplementaryView.updateBriefLabel(with: self.brief[version] ?? "No Update")
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
		
		for item in prepareSnapshot(whatsNew: dataSource) {
			diffableDataSource.appendItems([item], toSection: item.section)
		}
		
		return diffableDataSource
	}
	
	func prepareSnapshot(whatsNew: WhatsNew) -> [FeatureItem] {
		
		// Features
		let features: [String: String] = whatsNew.updates[whatsNew.version] ?? [:]
		var array: [FeatureItem] = []
		for (featureTitle, featureDescription) in features {
			array.append(FeatureItem(title: featureTitle, description: featureDescription, section: .newFeatures, image: FeatureSection.newFeatures.image))
		}
		
		// Fixes
		let fixes: [String] = whatsNew.fixes[whatsNew.version] ?? []
		for (value) in fixes {
			array.append(FeatureItem(title: "", description: value, section: .fixes, image: FeatureSection.fixes.image))
		}
		
		return array
	}
}



