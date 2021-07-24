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
	var navigationController: UINavigationController
	
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
	func showName(data: Task, persistentContainer: PersistentContainer?) {
		guard let p = persistentContainer else { return }
		let vc = ContentViewController(editType: .title, task: data, persistentContainer: p, coordinator: self)
        rootNavigationController?.pushViewController(vc, animated: true)
	}
	
	func showPriority(data: Task, persistentContainer: PersistentContainer?) {
		guard let p = persistentContainer else { return }
		let vm = TaskOptionsPriorityViewModel(task: data, persistentContainer: p)
		let vc = TaskOptionsPriorityViewController(coordinator: self, viewModel: vm)
        rootNavigationController?.pushViewController(vc, animated: true)
	}
	
	func showNotes(task: Task, note: TaskNote?, persistentContainer: PersistentContainer) {
		
		guard let note = note else {
			let newNote = TaskNote(context: persistentContainer.viewContext)
			newNote.createNotes(note: "Expand on your task", isButton: false)
			let vc = ContentViewController(editType: .newNote, task: task, taskNote: newNote, persistentContainer: persistentContainer, coordinator: self)
            rootNavigationController?.pushViewController(vc, animated: true)
			return
		}
		
		let vc = ContentViewController(editType: .notes, task: task, taskNote: note, persistentContainer: persistentContainer, coordinator: self)
        rootNavigationController?.pushViewController(vc, animated: true)
	}
	
	func showAlarm(data: Task, persistentContainer: PersistentContainer) {
		let viewModel = AlarmViewModel(data: data, persistentContainer: persistentContainer)
		let vc = AlarmViewController(viewModel: viewModel)
        rootNavigationController?.pushViewController(vc, animated: true)
	}
	
	func showRedactStyle(data: Task, persistentContainer: PersistentContainer) {
		let viewModel = RedactStyleViewModel(data: data, persistentContainer: persistentContainer)
		let vc = RedactStyleViewController(viewModel: viewModel)
        rootNavigationController?.pushViewController(vc, animated: true)
	}
	
	func dismissCurrentView() {
        rootNavigationController?.popViewController(animated: true)
	}
}

