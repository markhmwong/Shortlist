//
//  NewTaskStage3ViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 15/11/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class TaskCreationNotesViewController: UIViewController {
	
	private var viewModel: TaskCreationViewModel
	
	private var coordinator: NewTaskCoordinator
	
	private lazy var tableView: UICollectionView = {
		let view = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().createListLayout(appearance: .plain, separators: false, header: false, headerElementKind: "", footer: false, footerElementKind: ""))
		view.translatesAutoresizingMaskIntoConstraints = false
		view.delegate = self
		return view
	}()
	
	init(viewModel: TaskCreationViewModel, coordinator: NewTaskCoordinator) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = ThemeV2.Background
		
		// make collectionview
		createCollectionView()
		
		// prep data
		viewModel.configureDataSource(collectionView: tableView)
	}
	

	
	private func createCollectionView() {
		view.addSubview(tableView)
		tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
		tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
		tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
	}
}

extension TaskCreationNotesViewController: UICollectionViewDelegate {
	
	
	
}
