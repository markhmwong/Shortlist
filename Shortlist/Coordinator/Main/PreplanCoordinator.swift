//
//  PreplanCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 22/12/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

// Uses the Big List entity despite the name
class PreplanCoordinator: NSObject, Coordinator, UINavigationControllerDelegate, MainCoordinatorProtocol {
    
    weak var parentCoordinator: MainCoordinator?

    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
	
	func transparentBar(_ nav: UINavigationController) {
		nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
		nav.navigationBar.shadowImage = UIImage()
		nav.navigationBar.isTranslucent = true
	}
    
    // begin application
    func start(_ persistentContainer: PersistentContainer?) {
        navigationController.delegate = self
        let viewModel = MainViewModel()
		let vc = PreplanViewController(persistentContainer: persistentContainer, coordinator: self, viewModel: viewModel)
        let nav = UINavigationController(rootViewController: vc)
		transparentBar(nav)
		navigationController.present(nav, animated: true, completion: nil)
    }
	
	func showEditTask(_ persistentContainer: PersistentContainer?, task: Task, fetchedResultsController: NSFetchedResultsController<Day>, mainViewController: MainViewControllerProtocol) {
		let child = EditTaskCoordinator(navigationController: navigationController)
		child.parentCoordinator = nil
		child.task = task
		child.fetchedResultsController = fetchedResultsController
		child.mainViewController = mainViewController
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
	
	func showCategory(_ persistentContainer: PersistentContainer?, mainViewController: MainViewControllerProtocol) {
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


