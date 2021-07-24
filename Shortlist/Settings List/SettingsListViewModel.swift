//
//  SettingsListViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 2/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import MessageUI

class SettingsListViewModel: NSObject, MFMailComposeViewControllerDelegate {

	struct Constants {
		let appName = AppMetaData.name
		let appVersion = AppMetaData.version
		let deviceType = UIDevice().type
		let systemVersion = UIDevice.current.systemVersion
		
		let emailToRecipient = "hello@whizbangapps.xyz"
		let emailSubject = "Shortlist App Feedback"
		
		func emailBody() -> String {
			return """
			</br>
			</br>\(appName): \(appVersion!)\n
			</br>iOS: \(systemVersion)
			</br>Device: \(deviceType.rawValue)
			"""
		}
	}
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<SettingsListSection, SettingsListItem>! = nil
	
	private var dataSource: [SettingsListItem] = []
	
	private var persistentContainer: PersistentContainer
	
	private var coordinator: SettingsCoordinator
	
	init(persistentContainer: PersistentContainer, coordinator: SettingsCoordinator) {
		self.persistentContainer = persistentContainer
		self.coordinator = coordinator
		super.init()
		self.dataSource = prepareDataSource()
	}
	
	func getDiffableDataSource() -> UICollectionViewDiffableDataSource<SettingsListSection, SettingsListItem> {
		return diffableDataSource
	}
	
	private func prepareDataSource() -> [SettingsListItem] {
		// general section items
		// add 1 because it uses indexes
		let highPriorityLimit = (KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.HighPriorityLimit) ?? 0) + 1
		let mediumPriorityLimit = (KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.MediumPriorityLimit) ?? 0) + 1
		let lowPriorityLimit = (KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.LowPriorityLimit) ?? 0) + 1
		
		let priorityLimitItem = SettingsListItem(title: "Priority Limiter", subtitle: "High : \(highPriorityLimit)  Med : \(mediumPriorityLimit)  Low : \(lowPriorityLimit)", section: SettingsListSection.general, icon: "exclamationmark.circle.fill", disclosure: true, item: .priorityLimit)
		let statsItem = SettingsListItem(title: "Stats", section: SettingsListSection.general, icon: "waveform.path.ecg", disclosure: true, item: .stats)
		let taskReviewItem = SettingsListItem(title: "Yesterday's Brief", section: SettingsListSection.general, icon: "briefcase.fill", disclosure: true, item: .taskReview)
		
		// Privacy
		let privacyItem = SettingsListItem(title: "Privacy", subtitle: "A short statement on Shortlist's Privacy Policy.", section: SettingsListSection.privacy, icon: "lock.doc.fill", disclosure: true, item: .privacy)
		let permissionsItem = SettingsListItem(title: "Permissions", subtitle: "An outline of permissions used by Shortlist.", section: SettingsListSection.privacy, icon: "hand.raised.fill", disclosure: true, item: .permissions)
		
		// Suport items
		let reviewItem = SettingsListItem(title: "Review Shortlist", subtitle: "❤️ Support Indie Developers - Comment and Rate", section: SettingsListSection.support, icon: "heart.fill", item: .review)
		let contactItem = SettingsListItem(title: "Email Me", subtitle: "😃 Feedback, bug reports appreciated or a Hello", section: SettingsListSection.support, icon: "envelope.fill", item: .contact)
		let twitterItem = SettingsListItem(title: "Visit and follow me on Twitter", subtitle: "Updates @markhmwong", section: SettingsListSection.support, icon: "at.circle.fill", item: .twitter)
		let whatsNewItem = SettingsListItem(title: "Whats New", subtitle: "Notes about the latest version of Shortlist", section: .support, icon: "newspaper.fill", disclosure: true, item: .whatsNew)
		let aboutItem = SettingsListItem(title: "App Biography", subtitle: "Read a short story about Shortlist", section: .support, icon: "heart.text.square.fill", disclosure: true, item: .appBiography)
		
		// Data Items
		let clearAllDataItem = SettingsListItem(title: "Clear All Data", subtitle: "Every bit of Shortlist data wiped on this device", section: SettingsListSection.data, icon: "trash.fill", item: .clearAllData)
		let clearAllCategoriesItem = SettingsListItem(title: "Clear All Categories", subtitle: "Removes all categories. Unrecoverable.", section: SettingsListSection.data, icon: "xmark.bin.fill", item: .clearAllCategories)
		
		let supportDevItem = SettingsListItem(title: "Tip jar", subtitle: "Support me making apps", section: .tip, icon: "giftcard.fill", disclosure: true, item: .tip)
		
		return [supportDevItem, reviewItem, priorityLimitItem, taskReviewItem, statsItem, whatsNewItem, twitterItem, contactItem, aboutItem, reviewItem, clearAllDataItem, clearAllCategoriesItem, privacyItem, permissionsItem, ]
	}

	// MARK: - Configure cell
	private func configureCellRegistration() -> UICollectionView.CellRegistration<SettingsListCell, SettingsListItem> {
		let cellConfig = UICollectionView.CellRegistration<SettingsListCell, SettingsListItem> { (cell, indexPath, item) in
			cell.configureCell(with: item)
		}
		return cellConfig
	}
	
	// MARK: - Configure snapshot
	// configure snapshot
	private func configureSnapshot() -> NSDiffableDataSourceSnapshot<SettingsListSection, SettingsListItem> {
		
		var snapshot = NSDiffableDataSourceSnapshot<SettingsListSection, SettingsListItem>()
		snapshot.appendSections(SettingsListSection.allCases)
		
		for (_, item) in dataSource.enumerated() {
			snapshot.appendItems([item], toSection: item.section)
		}
		return snapshot
	}
	
	// configure diffable data source
	func configureDiffableDataSource(collectionView: UICollectionView) {
        let cellRego = self.configureCellRegistration()
		diffableDataSource = UICollectionViewDiffableDataSource<SettingsListSection, SettingsListItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(using: cellRego, for: indexPath, item: item)
			return cell
		}
		
		//Supplementary Views
		let headerRegistration = UICollectionView.SupplementaryRegistration
		<BaseCollectionViewListHeader>(elementKind: TaskOptionsViewController.CollectionListConstants.header.rawValue) {
			(supplementaryView, string, indexPath) in
			if let section = SettingsListSection(rawValue: indexPath.section) {
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
	
	// MARK: - data handling
	func deleteAllData() {
		let _ = persistentContainer.deleteAllRecordsIn(entity: Day.self)
		// Task/BigListTask entity is deletion is cascaded that's why it's missing
		let _ = persistentContainer.deleteAllRecordsIn(entity: CategoryList.self)
		let _ = persistentContainer.deleteAllRecordsIn(entity: DayStats.self)
		let _ = persistentContainer.deleteAllRecordsIn(entity: BackLog.self)
		let _ = persistentContainer.deleteAllRecordsIn(entity: Stats.self)
		let _ = persistentContainer.deleteAllRecordsIn(entity: StatsCategoryComplete.self)
		let _ = persistentContainer.deleteAllRecordsIn(entity: StatsCategoryIncomplete.self)
	}
	
	func deleteCategoryData() {
		let _ = persistentContainer.deleteAllRecordsIn(entity: CategoryList.self)
		let _ = persistentContainer.deleteAllRecordsIn(entity: BackLog.self)
	}
	
	// MARK: - Review
	func writeReview() {
		let productURL = URL(string: "https://apps.apple.com/app/id1480090462")!
		var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
		
		components?.queryItems = [
			URLQueryItem(name: "action", value: "write-review")
		]
		
		guard let writeReviewURL = components?.url else {
			return
		}
		
		UIApplication.shared.open(writeReviewURL)
	}
	
	func emailFeedback() {
		let mail: MFMailComposeViewController? = MFMailComposeViewController(nibName: nil, bundle: nil)
		guard let mailVc = mail else {
			return
		}
		
		mailVc.mailComposeDelegate = self
		mailVc.setToRecipients([Constants().emailToRecipient])
		mailVc.setSubject(Constants().emailSubject)
		
		mailVc.setMessageBody(Constants().emailBody(), isHTML: true)
		coordinator.showFeedback(mailVc)
	}
	
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true, completion: nil)
	}
}
