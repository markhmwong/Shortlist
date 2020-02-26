//
//  TaskLimitCoordinator.swift
//  Five
//
//  Created by Mark Wong on 5/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class TaskLimitCoordinator: NSObject, Coordinator, UINavigationControllerDelegate, CleanupProtocol {

	
    
    weak var parentCoordinator: SettingsCoordinator? = nil
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
	weak var parentViewController: SettingsViewController? = nil
	
	init(navigationController:UINavigationController, parentViewController: SettingsViewController?) {
        self.navigationController = navigationController
		self.parentViewController = parentViewController
    }
    
    // stats viewcontroller begin here
    func start(_ persistentContainer: PersistentContainer?) {
        navigationController.delegate = self
        guard let persistentContainer = persistentContainer else {
            return
        }
        let viewModel = TaskLimitViewModel(persistentContainer)
		let vc = TaskLimitViewController(persistentContainer: persistentContainer, coordinator: self, viewModel: viewModel, parentViewController: parentViewController)
		parentViewController?.navigationController?.pushViewController(vc, animated: true)

    }
	
	func dismiss() {
		parentViewController?.navigationController?.popViewController(animated: true)
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
    
	func cleanUpChildCoordinator() {
		NotificationCenter.default.post(name: Notification.Name(SettingsNavigationObserverKey.ReturnFromPriorityLimit.rawValue), object: self)
	}
}
