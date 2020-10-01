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
	
	var task: Task
	
	var persistentContainer: PersistentContainer?
	
	// New navigation stack
//	var navController: UINavigationController?
	
	init(navigationController: UINavigationController, task: Task) {
		self.navigationController = navigationController
		self.task = task
		super.init()
	}
	
	func start(_ persistentContainer: PersistentContainer?) {
		
		guard let persistentContainer = persistentContainer else {
			fatalError("PersistentContainer cannot be loaded")
		}
		self.persistentContainer = persistentContainer
		
		let viewModel = TaskDetailViewModel(task: task, persistentContainer: persistentContainer)
		let vc = TaskDetailViewController(viewModel: viewModel, coordinator: self)
		
		vc.navigationItem.rightBarButtonItem = UIBarButtonItem().taskOptionsButton(target: self, action: #selector(handleTaskOptions))
		navigationController.pushViewController(vc, animated: true)
	}
	
	func showPhoto(item: PhotoItem) {
		guard let persistentContainer = persistentContainer else {
			fatalError("PersistentContainer cannot be loaded")
		}
		
		let vc = PhotoViewController(item: item, persistentContainer: persistentContainer)
		let nav = UINavigationController(rootViewController: vc)
		vc.navigationController?.transparent()
		
		navigationController.present(nav, animated: true)
	}
	
	/*
	
		Handler Methods
	
	*/	
	@objc func handleDismiss() {
		navigationController.dismiss(animated: true) { }
	}
	
	@objc func handleTaskOptions() {
		guard let persistentContainer = persistentContainer else {
			fatalError("PersistentContainer cannot be loaded")
		}

		let taskOptionsCoordinator = TaskOptionsCoordinator(navigationController: navigationController, data: task)
		taskOptionsCoordinator.start(persistentContainer)
	}
}
