//
//  PermissionsViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 12/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class PermissionsViewController: UIViewController, UICollectionViewDelegate {
	
//	private let privacyService = PrivacyPermissionsService()
	
	private var viewModel: PermissionsViewModel
	
	private lazy var tableView: BaseCollectionView = {
		let view = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().createListLayout(appearance: .insetGrouped, separators: true, header: false, headerElementKind: ""))
		view.delegate = self
		return view
	}()
	
	init(viewModel: PermissionsViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = ThemeV2.Background
		navigationItem.title = "Permissions"
		view.addSubview(tableView)
		
		tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		
		viewModel.configureDiffableDataSource(collectionView: tableView)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let appSettings = URL(string: UIApplication.openSettingsURLString) {
			UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
		}
	}
}

