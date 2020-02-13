//
//  MultilistCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 16/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

// Uses the Big List entity despite the name
class BackLogCoordinator: NSObject, Coordinator, UINavigationControllerDelegate, CleanupProtocol {
    
    weak var parentCoordinator: MainCoordinator?

    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
	

    
    // begin application
    func start(_ persistentContainer: PersistentContainer?) {
        navigationController.delegate = self
        let viewModel = BackLogViewModel()
		let vc = BackLogViewController(persistentContainer: persistentContainer, coordinator: self, viewModel: viewModel)
        let nav = UINavigationController(rootViewController: vc)
		navigationController.present(nav, animated: true, completion: nil)
    }
	
	func showCategoryTasks(_ persistentContainer: PersistentContainer?, name: String?, parentViewController: BackLogViewController) {
		let child = CategoryTasksCoordinator(navigationController: navigationController, parentViewController: parentViewController)
		child.parentCoordinator = self
		child.categoryName = name
		childCoordinators.append(child)
		child.start(persistentContainer)
	}
	
	func dismiss() {
		navigationController.dismiss(animated: true, completion: nil)
	}

    func showAlertBox(_ message: String) {
        let alert = UIAlertController(title: "Hold up!", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		DispatchQueue.main.async {
			self.getTopMostViewController()?.present(alert, animated: true, completion: nil)
        }
    }
	
    func getTopMostViewController() -> UIViewController? {
		var topMostViewController = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController
        
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
	
	// called from preplan view controller and notifies observer we have left the preplan view
	func cleanUpChildCoordinator() {
		NotificationCenter.default.post(name: Notification.Name(MainNavigationObserverKey.ReturnFromBackLog.rawValue), object: self)
	}
    
//    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
//
//        if navigationController.viewControllers.contains(fromViewController) {
//            return
//        }
//
//        if let statsViewController = fromViewController as? StatsViewController {
//            childDidFinish(statsViewController.coordinator!)
//        }
//    }
}

