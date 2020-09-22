//
//  PriorityLimitViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 3/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

// MARK: - View Controller
class PriorityLimitViewController: UIViewController, UICollectionViewDelegate {
	
	private var item: SettingsListItem
	
	private var viewModel: PriorityLimitViewModel
	
	private lazy var tableView: BaseCollectionView = {
		let view = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().createListLayout(appearance: .insetGrouped, separators: false))
		view.delegate = self
		return view
	}()
	
	init(item: SettingsListItem, viewModel: PriorityLimitViewModel) {
		self.viewModel = viewModel
		self.item = item
		super.init(nibName: nil, bundle: nil)
		self.tableView.allowsMultipleSelection = false
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = ThemeV2.Background
		tableView.backgroundColor = ThemeV2.Background
		
		view.addSubview(tableView)
		
		tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		viewModel.configureDiffableDataSource(collectionView: tableView)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		viewModel.updateKeychain(indexPath: indexPath)
		collectionView.reloadData()
	}
}




