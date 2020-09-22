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
	
	var rootNavigationController: UINavigationController? = nil
	
	private var data: Task
	
	init(navigationController: UINavigationController, data: Task) {
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
		vc.title = "Task Options"
		
		let nav = UINavigationController(rootViewController: vc)
		rootNavigationController = nav
		navigationController.present(nav, animated: true)
	}
	
	// selected options
	func showName() {
		guard let r = rootNavigationController else { return }
		let vc = ContentViewController(editType: .name, data: data)
		r.pushViewController(vc, animated: true)
	}
	
	func showNotes() {
		guard let r = rootNavigationController else { return }

		let vc = ContentViewController(editType: .notes, data: data)
		r.pushViewController(vc, animated: true)
	}
	
	func showAlarm() {
		guard let r = rootNavigationController else { return }

		let viewModel = AlarmViewModel()
		let vc = AlarmViewController(viewModel: viewModel)
		r.pushViewController(vc, animated: true)
	}
	
	func showAllDay() {
		
	}
	
	func showRedactStyle() {
		guard let r = rootNavigationController else { return }
		let viewModel = RedactStyleViewModel()
		let vc = RedactStyleViewController(viewModel: viewModel)
		r.pushViewController(vc, animated: true)
	}
	
	func showDeleteTask() {
		guard let r = rootNavigationController else { return }

	}
}

