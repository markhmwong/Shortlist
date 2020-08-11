//
//  TaskView.swift
//  Shortlist
//
//  Created by Mark Wong on 28/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
	
	private var viewModel: TaskDetailViewModel
	
	private var coordinator: TaskDetailCoordinator
	
	private lazy var collectionView: BaseCollectionView! = nil
	
	init(viewModel: TaskDetailViewModel, coordinator: TaskDetailCoordinator) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.transparent()
		
		createCollectionView()
		viewModel.configureDataSource(collectionView: collectionView)
	}
	
	// create collection view
	func createCollectionView() {
		collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: viewModel.createCollectionViewLayout())
		collectionView.delegate = self
		view.addSubview(collectionView)

		collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}
}

extension TaskDetailViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("works")
	}
}
