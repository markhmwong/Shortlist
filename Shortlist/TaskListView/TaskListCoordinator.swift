//
//  Coordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 13/4/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit



class Coordinate: NSObject, Coordinator {
    var parentCoordinator: Coordinator? = nil
    
    var parentNavigationController: UINavigationController? = nil
    
    var rootNavigationController: UINavigationController? = nil
    
    var rootViewController: UIViewController? = nil
    
    var coreDataStack: CoreDataStack? = nil
    
    init(parentCoordinator: Coordinator? = nil, parentNavigationController: UINavigationController? = nil, rootNavigationController: UINavigationController? = nil, rootViewController: UIViewController? = nil, coreDataStack: CoreDataStack? = nil) {
        self.parentCoordinator = parentCoordinator
        self.parentNavigationController = parentNavigationController
        self.rootNavigationController = rootNavigationController
        self.coreDataStack = coreDataStack
        self.rootViewController = rootViewController
        super.init()
    }
    
    func start() {

    }
    
    func startWith(item: SLTask) {
        
    }
    
}

class TaskListCoordinator: Coordinate {
    
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
        let coordinator = TaskDetailsCoordinator(parentCoordinator: self, parentNavigationController: rootNavigationController)
        coordinator.startWith(item: item)
	}
}

class TaskDetailsCoordinator: Coordinate {
    
    override init(parentCoordinator: (any Coordinator)? = nil,
                  parentNavigationController: UINavigationController? = nil,
                  rootNavigationController: UINavigationController? = nil,
                  rootViewController: UIViewController? = nil,
                  coreDataStack: CoreDataStack? = nil) {
        super.init(parentCoordinator: parentCoordinator as! TaskListCoordinator,
                   parentNavigationController: parentNavigationController,
                   rootNavigationController: rootNavigationController,
                   rootViewController: rootViewController,
                   coreDataStack: coreDataStack)
    }
    
    override func startWith(item: SLTask) {
        let vm = TaskDetailsViewModel(item: item)
        rootViewController = TaskDetailsViewController(viewModel: vm, coordinator: self)
        
        guard let rvc = rootViewController else {
            return
        }
        rootNavigationController = UINavigationController(rootViewController: rvc)

        guard let rnc = rootNavigationController else { return }
        
        parentNavigationController?.present(rnc, animated: true)
    }
}
