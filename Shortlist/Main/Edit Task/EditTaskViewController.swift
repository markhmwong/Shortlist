//
//  EditTaskViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 22/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class EditTaskViewModel {
	
}

class EditTaskViewController: UIViewController {
	
	var viewModel: EditTaskViewModel?
	
	var persistentContainer: PersistentContainer?
	
	init(viewModel: EditTaskViewModel, persistentContainer: PersistentContainer) {
		self.persistentContainer = persistentContainer
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}
