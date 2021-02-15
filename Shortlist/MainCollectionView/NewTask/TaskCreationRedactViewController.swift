//
//  TaskCreationPhotoViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 28/11/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class TaskCreationRedactViewController: BaseCollectionViewController {
	
	private var viewModel: TaskCreationViewModel
	
	private var coordinator: NewTaskCoordinator
	
	init(viewModel: TaskCreationViewModel, coordinator: NewTaskCoordinator) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(collectionViewLayout: UICollectionViewLayout().createListLayout(appearance: .plain, separators: true, header: false, headerElementKind: "", footer: false, footerElementKind: ""))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = ThemeV2.Background
		
		viewModel.configureRedactDataSource(collectionView: self.collectionView)
	}
}
