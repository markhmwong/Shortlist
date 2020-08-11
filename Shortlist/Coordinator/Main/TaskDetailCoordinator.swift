//
//  TaskDetailCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 29/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class TaskDetailCoordinator: NSObject, Coordinator {
	var childCoordinators: [Coordinator] = []
	
	var navigationController: UINavigationController
	
	var task: TaskItem
	
	init(navigationController: UINavigationController, task: TaskItem) {
		self.navigationController = navigationController
		self.task = task
		super.init()
	}
	
	func start(_ persistentContainer: PersistentContainer?) {
		let viewModel = TaskDetailViewModel(task: task)
		let vc = TaskDetailViewController(viewModel: viewModel, coordinator: self)
		let nav = UINavigationController(rootViewController: vc)
		vc.navigationItem.leftBarButtonItem = UIBarButtonItem().backButton(target: self, action: #selector(handleDismiss))
		vc.navigationItem.rightBarButtonItem = UIBarButtonItem().optionsButton(target: self, action: #selector(handleTaskOptions))
		navigationController.present(nav, animated: true) {
			//
		}
	}
	
	@objc func handleDismiss() {
		navigationController.dismiss(animated: true) {
			//
		}
	}
	
	@objc func handleTaskOptions() {
		print("task options to do")
		// options should include - redacted mode, priority change, reminder, task title/note editing
	}
}
