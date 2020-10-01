//
//  AlarmViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 25/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

// MARK: - Alarm ViewController
class AlarmViewController: UIViewController, UICollectionViewDelegate {
	
	enum AlarmViewSupplementaryIds: String {
		case headerId = "com.whizbang.header.alarm"
		case footerId = "com.whizbang.footer.alarm"
	}
	
	// custom and preset times
	private lazy var tableView: BaseCollectionView = {
		let view = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().createListLayout(appearance: .insetGrouped, separators: false, header: true, headerElementKind: AlarmViewSupplementaryIds.headerId.rawValue, footer: true, footerElementKind: AlarmViewSupplementaryIds.footerId.rawValue))
		view.translatesAutoresizingMaskIntoConstraints = false
		view.delegate = self
		view.backgroundColor = .black
		return view
	}()
	
	private var viewModel: AlarmViewModel
	
	init(viewModel: AlarmViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Alarm"
		view.backgroundColor = .offWhite
		
		view.addSubview(tableView)
		tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		
		viewModel.configureDataSource(collectionView: tableView)
	}
}
