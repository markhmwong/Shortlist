//
//  TaskDetailsCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 14/6/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

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
        guard let cds = coreDataStack
        else {
            print("Core Data - \(coreDataStack)")
            return
        }
        let vm = TaskDetailsViewModel(item: item, coreData: cds)
        guard 
            let pc = parentCoordinator
        else
        {
            return
        }
        rootViewController = TaskDetailsViewController(viewModel: vm, coordinator: self, delegate: pc.rootViewController as! Refreshable)
        
        guard let rvc = rootViewController 
        else {
            return
        }
        rootNavigationController = UINavigationController(rootViewController: rvc)

        guard 
            let rnc = rootNavigationController,
            let pnc = parentNavigationController
        else {
            return
        }
        
        pnc.present(rnc, animated: true)
    }
    
    override func dismissCurrentView() {
        guard 
            let rnc = rootNavigationController
        else {
            return
        }
        rnc.dismiss(animated: true)
    }
}
