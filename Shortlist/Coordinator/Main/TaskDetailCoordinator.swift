//
//  TaskDetailCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 29/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class TaskDetailCoordinator: NSObject, Coordinator {
    func dismissCurrentView() {
        navigationController.popViewController(animated: true)
    }
    
	var childCoordinators: [Coordinator] = []
	
	// parent navigationController
	var navigationController: UINavigationController
	
	var task: Task
	
	var persistentContainer: PersistentContainer?
	
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
        let newBackButton = UIBarButtonItem(title: "Today", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("backAction")))
        newBackButton.tintColor = ThemeV2.TextColor.DefaultColor
        navigationController.navigationBar.topItem?.backBarButtonItem = newBackButton

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
    
    func showNotesInModal(task: Task, note: TaskNote?, persistentContainer: PersistentContainer) {
        guard let note = note else {
            // for a new note
            let newNote = TaskNote(context: persistentContainer.viewContext)
            newNote.createNotes(note: "There seems to be a problem recovering this note :(", isButton: false)
            let vc = ContentViewController(editType: .newNote, task: task, taskNote: newNote, persistentContainer: persistentContainer, coordinator: self)
            navigationController.pushViewController(vc, animated: true)
            return
        }
        
        let vc = ContentViewController(editType: .notes, task: task, taskNote: note, persistentContainer: persistentContainer, coordinator: self, modal: true)
        navigationController.present(vc, animated: true) {
            //
        }
    }
    
    func showNotesInEditMode(task: Task, note: TaskNote?, persistentContainer: PersistentContainer) {

        guard let note = note else {
            // for a new note
            let newNote = TaskNote(context: persistentContainer.viewContext)
            newNote.createNotes(note: "Expand on your task.. just a little", isButton: false)
            let vc = ContentViewController(editType: .newNote, task: task, taskNote: newNote, persistentContainer: persistentContainer, coordinator: self)
            navigationController.pushViewController(vc, animated: true)
            return
        }
        
        let vc = ContentViewController(editType: .notes, task: task, taskNote: note, persistentContainer: persistentContainer, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
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
