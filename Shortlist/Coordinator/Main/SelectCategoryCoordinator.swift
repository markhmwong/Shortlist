//
//  SelectCategory.swift
//  Shortlist
//
//  Created by Mark Wong on 23/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class SelectCategoryCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    var parentCoordinator: MainCoordinatorProtocol?
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
	var mainViewController: MainViewControllerProtocol
	
	init(navigationController:UINavigationController, viewController: MainViewControllerProtocol) {
        self.navigationController = navigationController
		self.mainViewController = viewController
    }
    
    // stats viewcontroller begins here
    func start(_ persistentContainer: PersistentContainer?) {
		navigationController.delegate = self
        guard let persistentContainer = persistentContainer else {
			let viewModel = SelectCategoryViewModel()
			let vc = SelectCategoryViewController(nil, coordinator: self, viewModel: viewModel, mainViewController: mainViewController)
			let nav = UINavigationController(rootViewController: vc)
			navigationController.present(nav, animated: true, completion: nil)
            return
        }
		let viewModel = SelectCategoryViewModel()
		let vc = SelectCategoryViewController(persistentContainer, coordinator: self, viewModel: viewModel, mainViewController: mainViewController)
		let nav = UINavigationController(rootViewController: vc)
		navigationController.pushViewController(vc, animated: true)
//		navigationController.present(nav, animated: true, completion: nil)
//		DispatchQueue.main.async {
//			self.getTopMostViewController()?.present(nav, animated: true, completion: nil)
//        }
    }
	
	func dimiss(_ persistentContainer: PersistentContainer?) {
		//get mainviewcontroller delegate
		self.mainViewController.updateCategory()
		navigationController.popViewController(animated: true)
//		navigationController.dismiss(animated: true) {
//
//		}
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
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
    }
}
