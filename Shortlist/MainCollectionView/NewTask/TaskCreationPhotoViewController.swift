//
//  TaskCreationPhotoViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 28/11/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class TaskCreationPhotoViewController: UIViewController {
	
	private var viewModel: TaskCreationViewModel
	
	private var coordinator: NewTaskCoordinator
	
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
		// ask for camera permission
		// collection view 1 section
	}
}
