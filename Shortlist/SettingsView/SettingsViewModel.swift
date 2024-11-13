//
//  SettingsViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 4/8/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

class SettingsViewModel: DatasourceSupervisor {
    
    typealias Item = SettingsItem
    
    typealias SectionIdentifier = SettingsSection
    
    enum SettingsSection: Int, CaseIterable {
        case main
    }
    
    private var items: [SettingsItem] = []
    
	private var diffableDatasource: UICollectionViewDiffableDataSource<SettingsSection, SettingsItem>! = nil

	init() {
        self.items = initialiseItems()
    }
    
    private func initialiseItems() -> [SettingsItem] {
		let taskLimit = SettingsItem(name: "Task Limit", section: .main, itemType: SettingsCellType.slider)
		let about = SettingsItem(name: "About", section: .main, itemType: .label)
		let privacyPolicy = SettingsItem(name: "Privacy Policy", section: .main, itemType: .label)

		guard let version: (String, String, String) = Version.getAppVersionComponentsAsStrings() else {
			assert(Version.getAppVersionComponentsAsStrings() != nil, "Version cannot be nil")
			let version = SettingsItem(name: "Version Unknown", section: .main, itemType: .label)
			return [taskLimit, about, privacyPolicy, version]
		}

		let versionItem = SettingsItem(name: "Version \(version.0).(\(version.1).\(version.2))", section: .main, itemType: .label)

        return [
			taskLimit,
			about,
			privacyPolicy,
			versionItem
		]
    }

    func configureDatasource(view: UICollectionView) {
        let settingsCellRegistration = UICollectionView.CellRegistration<SettingsCell, SettingsItem>.registerSettingsCell()
		let settingsCellSliderRegistration = UICollectionView.CellRegistration<SliderSettingsCell, SettingsItem>.registerSliderSettingsCell()

        diffableDatasource = UICollectionViewDiffableDataSource<SettingsSection, SettingsItem>(collectionView: view) { collectionView, indexPath, item in

			switch item.itemType {
				case .label:
					return collectionView.dequeueConfiguredReusableCell(using: settingsCellRegistration, for: indexPath, item: item)
				case .slider:
					return collectionView.dequeueConfiguredReusableCell(using: settingsCellSliderRegistration, for: indexPath, item: item)
			}

        }
        
        updateSnapshot(item: items)
    }
    
    func configureSnapshot(data: [SettingsItem]) -> NSDiffableDataSourceSnapshot<SettingsSection, SettingsItem> {
        var snapshot = NSDiffableDataSourceSnapshot<SettingsSection, SettingsItem>()
        snapshot.appendSections(SettingsSection.allCases)
        snapshot.appendItems(data)
        return snapshot
    }
    
    func updateSnapshot(item: [SettingsItem]) {
        let snapshot = configureSnapshot(data: item)
        diffableDatasource.apply(snapshot)
    }
    
    func refreshDatasource(item: [SettingsItem]) {

	}
}


