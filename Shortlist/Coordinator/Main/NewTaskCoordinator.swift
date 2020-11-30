//
//  NewTaskCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 12/11/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class NewTaskCoordinator: NSObject, Coordinator {
	var childCoordinators: [Coordinator] = []
	
	var navigationController: UINavigationController // vertical navigation back to main
	
	private var newTaskNavController: UINavigationController? // lateral navigation - steps through guide
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
		super.init()
	}
	
	func start(_ persistentContainer: PersistentContainer?) {
		guard let persistentContainer = persistentContainer else { return }
		let viewModel = TaskCreationViewModel(persistentContainer: persistentContainer)
		let vc = TaskCreationNameAndPriorityViewController(viewModel: viewModel, coordinator: self)
		vc.title = "Create Task"
		vc.navigationItem.leftBarButtonItem = UIBarButtonItem().cancelButton(target: self, action: #selector(handleCancel))
		
		newTaskNavController = UINavigationController(rootViewController: vc)
		guard let newTaskNavController = newTaskNavController else { return }
		navigationController.present(newTaskNavController, animated: true, completion: nil)
	}
	
	//selector methods
	@objc func handleCancel() {
		navigationController.dismiss(animated: true, completion: nil)
	}
	
	@objc func handleNextButton() {
		
	}
	
	@objc func handleDoneButton() {
		
	}
	
	// MARK: - Show Category
	func showCategory(viewModel: TaskCreationViewModel) {
		let vc = TaskCreationCategoryViewController(viewModel: viewModel, coordinator: self)
		vc.title = "Category"
		vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddNote))
		guard let newTaskNavController = newTaskNavController else { return }

		newTaskNavController.pushViewController(vc, animated: true)
	}
	
	// MARK: - Show Reminder
	func showReminder(viewModel: TaskCreationViewModel) {
		
		let vc = AlarmViewController(viewModel: AlarmViewModel(data: viewModel.task, persistentContainer: viewModel.persistentContainer))
		
//		let vc = TaskCreationReminderViewController(viewModel: viewModel, coordinator: self)
		guard let newTaskNavController = newTaskNavController else { return }
		vc.title = "Reminder"
		newTaskNavController.pushViewController(vc, animated: true)
	}
	
	func showRedact() {
		// Button is toggled instead
	}
	
	// MARK: - Show Photo
	func showPhoto(viewModel: TaskCreationViewModel) {
		let vc = TaskCreationPhotoViewController(viewModel: viewModel, coordinator: self)
		guard let newTaskNavController = newTaskNavController else { return }
		vc.title = "Photo"
		newTaskNavController.pushViewController(vc, animated: true)
	}
	
	// MARK: - Show Notes
	func showNotes(viewModel: TaskCreationViewModel) {
		let vc = TaskCreationNotesViewController(viewModel: viewModel, coordinator: self)
		guard let newTaskNavController = newTaskNavController else { return }
		vc.title = "Notes"
		newTaskNavController.pushViewController(vc, animated: true)
	}
	
	func dismiss() {
		navigationController.dismiss(animated: true, completion: nil)
	}
	
	//MARK: - Handlers
	@objc func handleAddNote() {
		
	}
}
