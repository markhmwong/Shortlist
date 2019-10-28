//
//  ReviewCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 17/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class ReviewCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    weak var parentCoordinator: MainCoordinator?
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
	var mainViewController: MainViewController?
	
	init(navigationController:UINavigationController, viewController: MainViewController?) {
        self.navigationController = navigationController
		self.mainViewController = viewController
    }
    
    // stats viewcontroller begins here
    func start(_ persistentContainer: PersistentContainer?) {
        navigationController.delegate = self
        guard let persistentContainer = persistentContainer else {
            print("Persistent Container not loaded")
            return
        }
        let viewModel = ReviewViewModel()
        let vc = ReviewViewController(persistentContainer: persistentContainer, coordinator: self, viewModel: viewModel)
        let nav = UINavigationController(rootViewController: vc)
        navigationController.present(nav, animated: true, completion: nil)
    }
	
	func dimiss(_ persistentContainer: PersistentContainer?) {
		//get mainviewcontroller delegate
		navigationController.dismiss(animated: true) {
			guard let mvc = self.mainViewController else {
				return
			}
			mvc.loadData()
		}
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
