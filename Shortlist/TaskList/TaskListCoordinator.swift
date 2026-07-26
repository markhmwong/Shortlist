//
//  Coordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 13/4/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit
import WidgetKit

class TaskListCoordinator: CoordinatorFacade<SLTask> {

    override init(parentCoordinator: (any Coordinator)? = nil,
                  parentNavigationController: UINavigationController? = nil,
                  rootNavigationController: UINavigationController? = nil,
				  rootViewController: UIViewController? = nil,
				  coreDataStack: CoreDataStack? = nil,
				  task: SLTask? = nil) {
		super.init(parentCoordinator: parentCoordinator,
				   parentNavigationController: parentNavigationController,
				   rootNavigationController: rootNavigationController,
				   rootViewController: rootViewController,
				   coreDataStack: coreDataStack,
				   task: task)
	}
    
    override func start() {
        let vm = TaskListViewModel(coreDataStack: coreDataStack)
		self.rootViewController = TaskListViewController(viewModel: vm, coordinator: self)
        
        guard let vc = self.rootViewController else { return }
        rootNavigationController?.setViewControllers([vc], animated: false)
    }
    
    func presentTaskDetails(item: SLTask) {
        let coordinator = TaskDetailsCoordinator(parentCoordinator: self,
                                                 parentNavigationController: rootNavigationController,
                                                 coreDataStack: coreDataStack)
        coordinator.start(with: item)
	}
    
    func presentAddGoal() {
        guard let rnc = rootNavigationController else { return }
        let addVC = AddGoalViewController()
        addVC.onSave = { [weak self] name, priority, reminder in
            guard let self, let cds = coreDataStack, let moc = cds.moc else { return }
            let task = SLTask(context: moc)
            task.newTask(name: name, priority: priority, reminder: reminder)
            cds.saveContext()
            if reminder != nil {
                NotificationService.shared.scheduleReminder(for: task)
            }
            WidgetCenter.shared.reloadAllTimelines()
        }
        let nav = UINavigationController(rootViewController: addVC)
        nav.modalPresentationStyle = .formSheet
        rnc.present(nav, animated: true)
    }

    func presentSettings() {
        let coordinator = SettingsCoordinator(parentCoordinator: self, parentNavigationController: rootNavigationController, rootNavigationController: UINavigationController(), rootViewController: nil, coreDataStack: coreDataStack)
        coordinator.start()
    }

    func showWelcomeIfNeeded() {
        guard LegacyStoreHandler.shouldShowWelcome,
              let rnc = rootNavigationController else { return }
        LegacyStoreHandler.removeV2StoreIfPresent()
        let welcomeVC = WelcomeViewController()
        welcomeVC.modalPresentationStyle = .fullScreen
        rnc.present(welcomeVC, animated: true)
    }
}


