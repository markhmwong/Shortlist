//
//  MainCoordinator.swift
//  Five
//
//  Created by Mark Wong on 19/8/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

protocol MainCoordinatorProtocol { }

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate, MainCoordinatorProtocol {
	
	var rootViewController: MainViewController?
	
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
		rootViewController = vc
		
		self.navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController.navigationBar.shadowImage = UIImage()
		self.navigationController.navigationBar.isTranslucent = true
		navigationController.pushViewController(vc, animated: false)
    }
	
	func showOnboarding(_ persistentContainer: PersistentContainer?) {
		guard let rvc = rootViewController else { return }
		let child = OnboardingCoordinator(navigationController: navigationController, viewController: rvc)
		child.parentCoordinator = self
		childCoordinators.append(child)
		child.start(persistentContainer)
	}
    
    // add stats view and coordinator
    func showSettings(_ persistentContainer: PersistentContainer?) {
        let child = SettingsCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(persistentContainer)
    }
	
	func showPreplan(_ persistentContainer: PersistentContainer?) {
		let child = PreplanCoordinator(navigationController: navigationController)
		child.parentCoordinator = self
		childCoordinators.append(child)
		child.start(persistentContainer)
	}
	
	func showBacklog(_ persistentContainer: PersistentContainer?) {
        let child = CategoryListCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(persistentContainer)
	}
    
	func showReview(_ persistentContainer: PersistentContainer?, automated: Bool) {
		let child = ReviewCoordinator(navigationController: navigationController, mainViewController: rootViewController, automated: automated)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(persistentContainer)
    }
	
	func showEditTask(_ persistentContainer: PersistentContainer?, task: Task, fetchedResultsController: NSFetchedResultsController<Day>, mainViewController: MainViewControllerProtocol) {
		let child = EditTaskCoordinator(navigationController: navigationController)
		child.parentCoordinator = self
		child.task = task
		child.fetchedResultsController = fetchedResultsController
		child.mainViewController = mainViewController
        childCoordinators.append(child)
        child.start(persistentContainer)
	}
	
	func showOptions(_ persistentContainer: PersistentContainer?) {
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

		alert.addAction(UIAlertAction(title: "Preplan", style: .default) { _ in
			self.showPreplan(persistentContainer)
		})

		alert.addAction(UIAlertAction(title: "Backlog", style: .default) { _ in
			self.showBacklog(persistentContainer)
		})
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
			
		})

		navigationController.present(alert, animated: true)
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
		var topMostViewController = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController
//        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
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
