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
	
	// parent navigationController
	var navigationController: UINavigationController
	
	var task: TaskItem
	
	var persistentContainer: PersistentContainer?
	
	var navController: UINavigationController?
	
	init(navigationController: UINavigationController, task: TaskItem) {
		self.navigationController = navigationController
		self.task = task
		super.init()
	}
	
	func start(_ persistentContainer: PersistentContainer?) {
		
		guard let persistentContainer = persistentContainer else {
			fatalError("PersistentContainer cannot be loaded")
		}
		self.persistentContainer = persistentContainer
		
		let viewModel = TaskDetailViewModel(task: task)
		let vc = TaskDetailViewController(viewModel: viewModel, coordinator: self)
		
		self.navController = UINavigationController(rootViewController: vc)
		
		guard let navController = navController else { return }
		
		vc.navigationItem.leftBarButtonItem = UIBarButtonItem().backButton(target: self, action: #selector(handleDismiss))
		vc.navigationItem.rightBarButtonItem = UIBarButtonItem().taskOptionsButton(target: self, action: #selector(handleTaskOptions))
		navigationController.present(navController, animated: true) {
			//
		}
	}
	
	@objc func handleDismiss() {
		navigationController.dismiss(animated: true) {
			//
		}
	}
	
	@objc func handleTaskOptions() {
		guard let persistentContainer = persistentContainer else {
			fatalError("PersistentContainer cannot be loaded")
		}
		guard let navController = navController else { return }

		let taskOptionsCoordinator = TaskOptionsCoordinator(navigationController: navController, data: task)
		taskOptionsCoordinator.start(persistentContainer)
	}
}
