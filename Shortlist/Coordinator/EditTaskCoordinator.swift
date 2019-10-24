//
//  EditTaskCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 22/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class EditTaskCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    weak var parentCoordinator: MainCoordinator?
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
	var task: Task?
	
	var fetchedResultsController: NSFetchedResultsController<Day>?
	
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
		
		let viewModel = EditTaskViewModel(with: task)
		let vc = EditTaskViewController(viewModel: viewModel, persistentContainer: persistentContainer, fetchedResultsController: fetchedResultsController!) //to do fix forced wrap
        let nav = UINavigationController(rootViewController: vc)
        navigationController.present(nav, animated: true, completion: nil)
    }
	
	func dimiss() {
		
		let topMostVc = getTopMostViewController()
		topMostVc?.dismiss(animated: true, completion: {
			//
		})
	}
    
    func childDidFinish(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if (coordinator === child) {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
	
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        return topMostViewController
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
    }
}
