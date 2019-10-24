//
//  MainCoordinator.swift
//  Five
//
//  Created by Mark Wong on 19/8/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    
    // begin application
    func start(_ persistentContainer: PersistentContainer?) {
        navigationController.delegate = self
        let viewModel = MainViewModel()
        let vc = MainViewController(persistentContainer: persistentContainer, viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    // add stats view and coordinator
    func showSettings(_ persistentContainer: PersistentContainer?) {
        let child = SettingsCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(persistentContainer)
    }
	
	func showBigList(_ persistentContainer: PersistentContainer?) {
        let child = MultiListCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(persistentContainer)
	}
    
	func showReview(_ persistentContainer: PersistentContainer?, mainViewController: MainViewController?) {
		let child = ReviewCoordinator(navigationController: navigationController, viewController: mainViewController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(persistentContainer)
    }
	
	func showEditTask(_ persistentContainer: PersistentContainer?, task: Task, fetchedResultsController: NSFetchedResultsController<Day>) {
		let child = EditTaskCoordinator(navigationController: navigationController)
		child.parentCoordinator = self
		child.task = task
		child.fetchedResultsController = fetchedResultsController
        childCoordinators.append(child)
        child.start(persistentContainer)
	}
    
    func showAlertBox(_ message: String) {
        let alert = UIAlertController(title: "Hold up!", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        navigationController.present(alert, animated: true, completion: nil)
		DispatchQueue.main.async {
			self.getTopMostViewController()?.present(alert, animated: true, completion: nil)
        }
    }
	
	func showCategory(_ persistentContainer: PersistentContainer?, mainViewController: MainViewController) {
		let child = SelectCategoryCoordinator(navigationController: navigationController, viewController: mainViewController)
		child.parentCoordinator = self
		childCoordinators.append(child)
		child.start(persistentContainer)
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
