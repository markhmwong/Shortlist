//
//  TaskOptionsPriorityViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 18/2/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit

class TaskOptionsPriorityViewController: BaseCollectionViewController {
	
	private var viewModel: TaskOptionsPriorityViewModel
	
	private var coordinator: TaskOptionsCoordinator
	
	init(coordinator: TaskOptionsCoordinator, viewModel: TaskOptionsPriorityViewModel) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(collectionViewLayout: UICollectionViewLayout().createCollectionViewLargeCells(xPadding: 10))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		viewModel.configureDataSource(collectionView: collectionView)
	}
	
}
