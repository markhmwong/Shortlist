//
//  ReviewCollectionListViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 17/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class ReviewCollectionListViewController: UIViewController {
	
	static let headerElementKind: String = "com.whizbang.header.review"
	
	private var viewModel: ReviewCollectionListViewModel
	
	private lazy var tableView: UICollectionView = {
		let view = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().createCollectionViewLayout(header: true, elementKind: ReviewCollectionListViewController.headerElementKind))
		view.allowsMultipleSelection = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var doneButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = 10.0
		button.backgroundColor = ThemeV2.Button.BackgroundColor
		button.setTitle("Add to Today's list", for: .normal)
		button.setTitleColor(ThemeV2.Button.DefaultTextColor, for: .normal)
		button.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
		return button
	}()
	
	init(viewModel: ReviewCollectionListViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(tableView)
		view.addSubview(doneButton)
		
		tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		
		doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100.0).isActive = true
		doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		doneButton.widthAnchor.constraint(equalToConstant: view.frame.width / 1.5).isActive = true
		// viewmodel call to configure collectionview
		viewModel.configureDiffableDataSource(collectionView: tableView)
	}
	
	@objc func handleDoneButton() {
		if let indexPaths = tableView.indexPathsForSelectedItems {
			for index in indexPaths {
				let cell = tableView.cellForItem(at: index) as! TaskCellV2
				_ = cell.item
			}
		}
		
		
		
	}
}


