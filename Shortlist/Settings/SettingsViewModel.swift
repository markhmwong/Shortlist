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
		var aboutItem = GeneralSettingsItem(title: "About", section: .main, itemType: .label)
		aboutItem.performAction = { [unowned coordinator] in
			coordinator.showAbout()
		}
		aboutItem.titleFontConfig(textStyle: .body, weight: .bold)

		var privacyPolicyItem = GeneralSettingsItem(title: "Privacy Policy", section: .main, itemType: .label)
		privacyPolicyItem.performAction = { [unowned coordinator] in
			coordinator.showPrivacyPolicy()
		}
		privacyPolicyItem.titleFontConfig(textStyle: .body, weight: .bold)

		let versionString: String
		if let v = Version.getAppVersionComponentsAsStrings() {
			versionString = "Version \(v.0).\(v.1).\(v.2)"
		} else {
			versionString = "Version Unknown"
		}
		var versionItem = GeneralSettingsItem(title: versionString, section: .main, itemType: .label)
		versionItem.titleFontConfig(textStyle: .caption1)

		return [aboutItem, privacyPolicyItem, versionItem].map { AnySettingsItem($0) }
    }

	func configureDatasource(view: UICollectionView) {
        let settingsCellRegistration = UICollectionView.CellRegistration<SettingsCell, AnySettingsItem>.registerSettingsCell()
		diffableDatasource = UICollectionViewDiffableDataSource<SettingsSection, AnySettingsItem>(collectionView: view) { collectionView, indexPath, item in
			return collectionView.dequeueConfiguredReusableCell(using: settingsCellRegistration, for: indexPath, item: item)
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


