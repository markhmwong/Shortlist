//
//  SelectCategory.swift
//  Shortlist
//
//  Created by Mark Wong on 23/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class SelectCategoryCoordinator: NSObject, Coordinator, UINavigationControllerDelegate, CleanupProtocol {

    var parentCoordinator: MainCoordinatorProtocol?
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
	var mainViewController: MainViewControllerProtocol
	
	// main view controller is passed here to update the main screen when the category is selected
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
			navigationController.pushViewController(nav, animated: true)
            return
        }
		let viewModel = SelectCategoryViewModel()
		let vc = SelectCategoryViewController(persistentContainer, coordinator: self, viewModel: viewModel, mainViewController: mainViewController)
		navigationController.pushViewController(vc, animated: true)
    }
	
	func dismissCurrentView() {
		//get mainviewcontroller delegate
		self.mainViewController.updateCategory()
		navigationController.popViewController(animated: true)
	}
    
    func childDidFinish(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if (coordinator === child) {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
	func cleanUpChildCoordinator() {
		NotificationCenter.default.post(name: Notification.Name(MainNavigationObserverKey.ReturnFromCategorySelection.rawValue), object: self)
	}
}
