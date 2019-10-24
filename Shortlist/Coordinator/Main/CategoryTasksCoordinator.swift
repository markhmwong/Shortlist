//
//  CategoryTasksCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 18/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

import UIKit

class CategoryTasksCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    weak var parentCoordinator: MultiListCoordinator?
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    
    // stats viewcontroller begin here
    func start(_ persistentContainer: PersistentContainer?) {
        navigationController.delegate = self
        guard let persistentContainer = persistentContainer else {
            print("Persistent Container not loaded")
            return
        }
		
		let vc = CategoryTaskListViewController(persistentContainer: persistentContainer)
		let nav = UINavigationController(rootViewController: vc)
		DispatchQueue.main.async {
            self.getTopMostViewController()?.present(nav, animated: true, completion: nil)
        }
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        return topMostViewController
    }
    
    func childDidFinish(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if (coordinator === child) {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
    }
}
