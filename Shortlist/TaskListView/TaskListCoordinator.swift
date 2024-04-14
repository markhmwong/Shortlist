//
//  Coordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 13/4/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

protocol Coordinator {
    var rootViewController: UIViewController? { get }
    
    var navigationController: UINavigationController? { get }
    
    var coreDataStack: CoreDataStack? { get }
    
    func start()
}

class Coordinate: NSObject, Coordinator {
    var navigationController: UINavigationController?
    
    var rootViewController: UIViewController?
    
    var coreDataStack: CoreDataStack? = nil
    
    init(navigationController: UINavigationController, rootViewController: UIViewController? = nil, coreDataStack: CoreDataStack? = nil) {
        self.navigationController = navigationController
        self.coreDataStack = coreDataStack
        self.rootViewController = rootViewController
        super.init()
    }
    
    func start() {

    }
    
}

class TaskListCoordinator: Coordinate {
    
    override init(navigationController: UINavigationController, rootViewController: UIViewController? = nil, coreDataStack: CoreDataStack? = nil) {
        super.init(navigationController: navigationController, rootViewController: rootViewController, coreDataStack: coreDataStack)
    }
    
    override func start() {
        let vm = TaskListViewModel(coreDataStack: coreDataStack)
        self.rootViewController = TaskListViewController(viewModel: vm)
        
        guard let vc = self.rootViewController else { return }
        navigationController?.setViewControllers([vc], animated: false)
    }
    
}
