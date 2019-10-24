//
//  MultilistCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 16/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class MultiListCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    weak var parentCoordinator: MainCoordinator?

    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    
    // begin application
    func start(_ persistentContainer: PersistentContainer?) {
        navigationController.delegate = self
        let viewModel = MultiListViewModel()
		let vc = MultiListViewController(persistentContainer: persistentContainer, coordinator: self, viewModel: viewModel)
        let nav = UINavigationController(rootViewController: vc)
		nav.modalPresentationStyle = .fullScreen
		navigationController.present(nav, animated: true, completion: nil)
    }
	
	func showCategoryTasks(_ persistentContainer: PersistentContainer?) {
		let child = CategoryTasksCoordinator(navigationController: navigationController)
		child.parentCoordinator = self
		childCoordinators.append(child)
		child.start(persistentContainer)
	}
	
	func dismiss() {
		navigationController.dismiss(animated: true, completion: nil)
	}

    func showAlertBox(_ message: String) {
        let alert = UIAlertController(title: "Hold up!", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        navigationController.present(alert, animated: true, completion: nil)
		DispatchQueue.main.async {
			self.getTopMostViewController()?.present(alert, animated: true, completion: nil)
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
        
        if let statsViewController = fromViewController as? StatsViewController {
            childDidFinish(statsViewController.coordinator!)
        }
    }
}

