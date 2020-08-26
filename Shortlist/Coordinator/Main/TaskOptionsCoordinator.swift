//
//  TaskOptionsCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 19/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class TaskOptionsCoordinator: NSObject, Coordinator {
	internal var childCoordinators: [Coordinator] = []
	
	// parent navcontroller
	internal var navigationController: UINavigationController
	
	private var data: TaskItem
	
	init(navigationController: UINavigationController, data: TaskItem) {
		self.data = data
		self.navigationController = navigationController
		super.init()
	}
	
	func start(_ persistentContainer: PersistentContainer?) {
		guard let persistentContainer = persistentContainer else {
			fatalError("TaskOptionsCoordinator: Cannot load Persistent Container")
		}
		
		let viewModel = TaskOptionsViewModel(data: data, persistentContainer: persistentContainer)
		let vc = TaskOptionsViewController(viewModel: viewModel, coordinator: self)
		vc.title = "Settings"
		navigationController.pushViewController(vc, animated: true)
	}
	
	
	// selected options
	func showName() {
		let vc = ContentViewController(editType: .name, data: data)
		navigationController.pushViewController(vc, animated: true)
	}
	
	func showNotes() {
		let vc = ContentViewController(editType: .notes, data: data)
		navigationController.pushViewController(vc, animated: true)
	}
	
	func showAlarm() {
		let viewModel = AlarmViewModel()
		let vc = AlarmViewController(viewModel: viewModel)
		navigationController.pushViewController(vc, animated: true)
	}
	
	func showAllDay() {
		
	}
	
	func showRedact() {
		
	}
	
	func showDeleteTask() {
		
	}
}

