//
//  Coordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 3/8/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

public class CoordinatorFacade: NSObject, Coordinator {
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
    
    func dismissEntireStack() {
        
    }
    
    @objc
	func dismissCurrentView() {

    }
    
}
