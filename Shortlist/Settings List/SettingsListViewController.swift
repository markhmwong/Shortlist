//
//  SettingsListViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 31/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class SettingsListViewController: UIViewController {
	
	private var viewModel: SettingsListViewModel
	
	private var persistentContainer: PersistentContainer
	
	private var coordinator: SettingsCoordinator
	
	private lazy var tableView: BaseCollectionView = {
		let view = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().createListLayout(appearance: .insetGrouped))
		view.delegate = self
		return view
	}()
	
	init(viewModel: SettingsListViewModel, persistentContainer: PersistentContainer, coordinator: SettingsCoordinator) {
		self.viewModel = viewModel
		self.persistentContainer = persistentContainer
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		createTableView()
	}
	
	private func createTableView() {
		view.addSubview(tableView)
		
		tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

		viewModel.configureDiffableDataSource(collectionView: tableView)
	}
	
	func confirmDeleteAllData() {
		let closure = { () in
			self.viewModel.deleteAllData()
		}
		coordinator.deleteBox(deletionClosure: closure, title: "Would you like to delete all data?", message: "Data is unrecoverable")
	}
	
	func loadTwitter() {
		guard let url = URL(string: "https://www.twitter.com/markhmwong") else { return }
		UIApplication.shared.open(url)
	}
}

extension SettingsListViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let cell = collectionView.cellForItem(at: indexPath) as! SettingsListCell

		guard let item = cell.item else { return }

		switch item.item {
			case .taskReview:
				coordinator.showReview(persistentContainer, automated: false)
			case .priorityLimit:
				coordinator.showTaskLimit(persistentContainer, item: item)
			case .stats:
				coordinator.showStats(persistentContainer)
			case .appBiography:
				coordinator.showAbout(persistentContainer)
			case .privacy:
				coordinator.showPrivacy()
			case .clearAllCategories:
				viewModel.deleteCategoryData()
			case .clearAllData:
				viewModel.deleteAllData()
			case .review:
				viewModel.writeReview()
			case .contact:
				viewModel.emailFeedback()
			case .whatsNew:
				coordinator.showWhatsNew()
			case .tip:
				coordinator.showTipJar()
			case .permissions:
				coordinator.showPermissions()
			case .twitter:
				loadTwitter()
		}
		collectionView.deselectItem(at: indexPath, animated: true)
	}
}
