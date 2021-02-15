//
//  NewTaskStage3ViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 15/11/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class NewTaskCoordinator {
	
}

class TaskCreationNotesViewController: BaseCollectionViewController {
	
	private var viewModel: TaskCreationViewModel
	
	private var coordinator: NewTaskCoordinator
	
//	private lazy var tableView: UICollectionView = {
//		let view = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().createListLayout(appearance: .plain, separators: true, header: false, headerElementKind: "", footer: false, footerElementKind: ""))
//		view.translatesAutoresizingMaskIntoConstraints = false
//		view.delegate = self
//		return view
//	}()
	
	init(viewModel: TaskCreationViewModel, coordinator: NewTaskCoordinator) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(collectionViewLayout: UICollectionViewLayout().createListLayout(appearance: .plain, separators: true, header: false, headerElementKind: "", footer: false, footerElementKind: ""))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func handleAddNote() {
		// add extra note item
		if let alertController = viewModel.addNoteItem() {
			
			self.present(alertController, animated: true) {
//				completion handler
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
//		view.backgroundColor = ThemeV2.Background
		// configure navigation button
		navigationItem.rightBarButtonItem = UIBarButtonItem().addButton(self, action: #selector(handleAddNote), imageName: "plus")
		

		
		// prep data
		viewModel.delegate = self
		viewModel.configureDataSource(collectionView: self.collectionView)
	}
	
	func textViewDidChange(newText: String) {
		collectionView.collectionViewLayout.invalidateLayout()
//		collectionViewLayout.invalidateLayout()
	}
}
