//
//  Coordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 13/4/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit



class TaskListCoordinator: CoordinatorFacade {
    
    override init(parentCoordinator: (any Coordinator)? = nil,
                  parentNavigationController: UINavigationController? = nil,
                  rootNavigationController: UINavigationController? = nil,
                  rootViewController: UIViewController? = nil,
                  coreDataStack: CoreDataStack? = nil) {
        super.init(parentCoordinator: parentCoordinator,
                   parentNavigationController: parentNavigationController,
                   rootNavigationController: rootNavigationController,
                   rootViewController: rootViewController,
                   coreDataStack: coreDataStack)
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
        coordinator.startWith(item: item)
	}
    
    func presentSettings() {
        let coordinator = SettingsCoordinator(parentCoordinator: self, parentNavigationController: rootNavigationController, rootNavigationController: nil, rootViewController: nil, coreDataStack: coreDataStack)
        coordinator.start()
    }
}


