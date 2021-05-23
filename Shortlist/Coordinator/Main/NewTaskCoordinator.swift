//
//  NewTaskCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 12/11/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class NewTaskCoordinator: NSObject, Coordinator {
    func dismissCurrentView() {
        //
    }
	var childCoordinators: [Coordinator] = []
	
	var navigationController: UINavigationController // vertical navigation back to main
	
	private var newTaskNavController: UINavigationController? // lateral navigation - steps through guide
	
    private var newTaskNav: UINavigationController! = nil
    
    private var newTaskVc: NewTaskViewController! = nil
    
    private var persistentContainer: PersistentContainer! = nil
    
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
		super.init()
	}
	
	func start(_ persistentContainer: PersistentContainer?) {
		// New UI
		guard let persistentContainer = persistentContainer else { return }
        self.persistentContainer = persistentContainer
        let vm = NewTaskViewModel(persistentContainer: persistentContainer)
        newTaskVc = NewTaskViewController(viewModel: vm, coordinator: self)
        newTaskVc.title = "New Task"
        // left nav
        newTaskVc.navigationItem.leftBarButtonItem = UIBarButtonItem().dismissButton(target: self, action: #selector(handleBack))
        // right nav
        newTaskVc.navigationItem.rightBarButtonItem = UIBarButtonItem().addButton(self, action: #selector(handleAddTask), imageName: "plus")
        self.newTaskNav = UINavigationController(rootViewController: newTaskVc)

        
		navigationController.present(newTaskNav, animated: true, completion: nil)
	}
    
    @objc func handleBack() {
        newTaskNav?.dismiss(animated: true, completion: nil)
    }
	
    @objc func handleAddTask() {
        newTaskVc.addNewTask()
        self.handleBack()
//        let taskLow: Task = Task(context: persistentContainer.viewContext)
//        taskLow.create(context: persistentContainer.viewContext, taskName: "🚀 Quick tasks that aren't necessarily important or something to remind yourself, like catching up on TV shows or replying to emails.", categoryName: "Uncategorized", createdAt: Calendar.current.today(), reminderDate: Calendar.current.today(), priority: Int(Priority.low.value), redact: 0)
//        taskLow.details = "The limit on a low priority task is 1 - 3. Quick tasks that don't need a lot of time spent on."
//        if let day = persistentContainer.fetchDayManagedObject(forDate: Calendar.current.today()) {
//            day.addToDayToTask(taskLow)
//            persistentContainer.saveContext()
//            self.handleBack()
//        }
        navigationController.dismiss(animated: true, completion: nil)
    }
}
