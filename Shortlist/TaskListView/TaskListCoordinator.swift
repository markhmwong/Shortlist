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
    
    init(parentCoordaintor: Coordinator? = nil, parentNavigationController: UINavigationController? = nil, rootNavigationController: UINavigationController? = nil, rootViewController: UIViewController? = nil, coreDataStack: CoreDataStack? = nil) {
        self.parentCoordinator = parentCoordaintor
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
    
    override init(parentCoordaintor: (any Coordinator)? = nil, 
                  parentNavigationController: UINavigationController? = nil,
                  rootNavigationController: UINavigationController? = nil,
                  rootViewController: UIViewController? = nil,
                  coreDataStack: CoreDataStack? = nil) {
        super.init(parentCoordaintor: parentCoordaintor, 
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
//        let coordinate = TaskDetailsCoordinator

//        coordinate.start()
//		self.rootNavigationController?.pushViewController(vc, animated: true)
	}
}

class TaskDetailsCoordinator: Coordinate {
//    var _parentNavigationController: UINavigationController? {
//        set {
//            self.parentNavigationController = newValue
//        }
//        get {
//            return self.navigationController
//        }
//    }
//    
//    var _rootViewController: UIViewController?
//    
//    var navigationController: UINavigationController?
    
//    var coreDataStack: CoreDataStack?
    
    override init(parentCoordaintor: (any Coordinator)? = nil, 
                  parentNavigationController: UINavigationController? = nil,
                  rootNavigationController: UINavigationController? = nil,
                  rootViewController: UIViewController? = nil,
                  coreDataStack: CoreDataStack? = nil) {
        super.init(parentCoordaintor: parentCoordaintor,
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
