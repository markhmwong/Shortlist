//
//  SettingsViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 4/8/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

class SettingsViewModel: DatasourceSupervisor {
    
    typealias Item = AnySettingsItem

    typealias SectionIdentifier = SettingsSection
    
    enum SettingsSection: Int, CaseIterable {
        case main
    }
    
	var items: [AnySettingsItem] = []

	var diffableDatasource: UICollectionViewDiffableDataSource<SettingsSection, AnySettingsItem>! = nil

	let coordinator: SettingsCoordinator

	init(coordinator: SettingsCoordinator) {
		self.coordinator = coordinator
        self.items = initialiseItems()
    }
    
	private func initialiseItems() -> [AnySettingsItem] {
		let limit = SettingsManager.shared.fetchTaskLimit()
		let taskLimitItem = SettingsTaskLimitItem(title: "Task Limit", section: .main, value: String(limit), itemType: SettingsCellType.slider)
		var aboutItem = GeneralSettingsItem(title: "About", section: .main, itemType: .label)

		aboutItem.performAction = { [unowned coordinator] in
			/// triggered from didSelectItem in the viewcontroller
			coordinator.showAbout()
		}
		aboutItem.titleFontConfig(textStyle: .body, weight: .bold)
		var privacyPolicyItem = GeneralSettingsItem(title: "Privacy Policy", section: .main, itemType: .label)
		privacyPolicyItem.performAction = { [unowned coordinator] in
			coordinator.showPrivacyPolicy()
		}

		privacyPolicyItem.titleFontConfig(textStyle: .body, weight: .bold)

		guard let version: (String, String, String) = Version.getAppVersionComponentsAsStrings() else {
			assert(Version.getAppVersionComponentsAsStrings() != nil, "Version cannot be nil")
			var versionItem = GeneralSettingsItem(title: "Version Unknown", section: .main, itemType: .label)
			versionItem.titleFontConfig(textStyle: .caption1)

			let items: [AnySettingsItem] = [
				AnySettingsItem(taskLimitItem),
				AnySettingsItem(aboutItem),
				AnySettingsItem(privacyPolicyItem),
				AnySettingsItem(versionItem)
			]
			return items
		}

		var versionItem = GeneralSettingsItem(title: "Version \(version.0).\(version.1).\(version.2)", section: .main, itemType: .label)
		versionItem.titleFontConfig(textStyle: .caption1)

		let finalItems: [any SettingsItemProtocol] = [
			taskLimitItem,
			aboutItem,
			privacyPolicyItem,
			versionItem
		]

		let castedItems = finalItems.map { AnySettingsItem($0) }

		return castedItems
    }

	func configureDatasource(view: UICollectionView) {
        let settingsCellRegistration = UICollectionView.CellRegistration<SettingsCell, AnySettingsItem>.registerSettingsCell()
		let settingsCellSliderRegistration = UICollectionView.CellRegistration<SliderSettingsCell, AnySettingsItem>.registerSliderSettingsCell()
		diffableDatasource = UICollectionViewDiffableDataSource<SettingsSection, AnySettingsItem>(collectionView: view) { collectionView, indexPath, item in
			switch item.itemType {
				case .label:
					return collectionView.dequeueConfiguredReusableCell(using: settingsCellRegistration, for: indexPath, item: item)
				case .slider:
					return collectionView.dequeueConfiguredReusableCell(using: settingsCellSliderRegistration, for: indexPath, item: item)
			}
		}
        
        updateSnapshot(item: items)
    }
    
    func configureSnapshot(data: [AnySettingsItem]) -> NSDiffableDataSourceSnapshot<SettingsSection, AnySettingsItem> {
        var snapshot = NSDiffableDataSourceSnapshot<SettingsSection, AnySettingsItem>()
        snapshot.appendSections(SettingsSection.allCases)
        snapshot.appendItems(data)
        return snapshot
    }
    
    func updateSnapshot(item: [AnySettingsItem]) {
        let snapshot = configureSnapshot(data: item)
        diffableDatasource.apply(snapshot)
    }
    
    func refreshDatasource(item: [AnySettingsItem]) {

	}
}


