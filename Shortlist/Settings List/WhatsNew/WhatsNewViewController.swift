//
//  WhatsNewViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 7/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class WhatsNewViewController: UIViewController {
	
	static let header: String = "WhatsNewHeader"
	
	private var tableView: BaseCollectionView = {
		let view = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().createListLayoutWithSingleHeader(appearance: .plain, separators: false, header: true, elementKind: header))
		return view
	}()
	
	private var viewModel: WhatsNewViewModel
	
	init(viewModel: WhatsNewViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = ThemeV2.Background
		
		view.addSubview(tableView)
		tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		viewModel.configureDiffableDataSource(collectionView: tableView)

		

	}
}

