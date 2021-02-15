//
//  PermissionsViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 12/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

enum PermissionSection: CaseIterable {
	case main
}

struct PermissionItem: Hashable {
	var title: String
	var image: String
	var description: String
	var section: PermissionSection
	var state: Bool
}

class PermissionsViewModel: NSObject {
	
	private static let header: String = "com.whizbang.tableview.headerId"
	
	private var privacyPermissions: PrivacyPermissionsService
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<PermissionSection, PermissionItem>! = nil
	
	init(privacyPermissions: PrivacyPermissionsService) {
		self.privacyPermissions = privacyPermissions
		super.init()
	}
}

// MARK: - Configure Collection View methods
extension PermissionsViewModel {
	
	// configure diffable data source
	func configureDiffableDataSource(collectionView: UICollectionView) {
		diffableDataSource = UICollectionViewDiffableDataSource<PermissionSection, PermissionItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellRegistration(), for: indexPath, item: item)
			return cell
		}
		
		//Supplementary Views
		let headerRegistration = UICollectionView.SupplementaryRegistration
		<SupplementaryViewHeader>(elementKind: PermissionsViewModel.header) {
			(supplementaryView, string, indexPath) in
			supplementaryView.updateBriefLabel(with: "To Do")
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
	private func configureCellRegistration() -> UICollectionView.CellRegistration<PermissionsCell, PermissionItem> {
		let cellConfig = UICollectionView.CellRegistration<PermissionsCell, PermissionItem> { (cell, indexPath, item) in
			// configure cell
			cell.configureCell(with: item)
		}
		return cellConfig
	}
	
	// configure diffable datasource snapshot
	func configureSnapshot() -> NSDiffableDataSourceSnapshot<PermissionSection, PermissionItem> {
		var diffableDataSource = NSDiffableDataSourceSnapshot<PermissionSection, PermissionItem>()
		diffableDataSource.appendSections(PermissionSection.allCases)
		let dataSource = prepareDataSource()
		
		for item in dataSource {
			diffableDataSource.appendItems([item], toSection: item.section)
		}
		
		return diffableDataSource
	}
	
	func prepareDataSource() -> [PermissionItem] {
		let cameraItem = PermissionItem(title: "Camera", image: "camera.fill", description: "Enables the use of the camera, to attach photos to the task.", section: .main, state: privacyPermissions.isCameraAllowed())
		let biometricsItem = PermissionItem(title: "Face ID/ Touch ID", image: "faceid", description: "Allows the use of Face ID / Touch ID to lock and redact text of a specific task.", section: .main, state: privacyPermissions.isBiometricsAllowed())
		let remindersItem = PermissionItem(title: "Reminders", image: "calendar", description: "Allows access to the Rmeinders App and allow data to be imported.", section: .main, state: privacyPermissions.isRemindersAllowed())
		let photoItem = PermissionItem(title: "Photo Library", image: "photo.fill", description: "Allows access to your photo library to import photos.", section: .main, state: privacyPermissions.isPhotosAllowed())
		
		return [cameraItem, biometricsItem, remindersItem, photoItem]
	}
}
