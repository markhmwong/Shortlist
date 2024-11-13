//
//  SettingsCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 4/8/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

class SettingsCoordinator: CoordinatorFacade {
    
    override init(parentCoordinator: (any Coordinator)? = nil, parentNavigationController: UINavigationController? = nil, rootNavigationController: UINavigationController? = nil, rootViewController: UIViewController? = nil, coreDataStack: CoreDataStack? = nil) {
        super.init(parentCoordinator: parentCoordinator, parentNavigationController: parentNavigationController, rootNavigationController: rootNavigationController, rootViewController: rootNavigationController, coreDataStack: coreDataStack)
    }
    
    override func start() {
        let vm = SettingsViewModel()
        let vc = SettingsViewController(viewModel: vm, coordinator: self)
        
        parentNavigationController?.pushViewController(vc, animated: true)
    }
}
