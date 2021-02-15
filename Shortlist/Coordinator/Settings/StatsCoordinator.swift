//
//  StatsCoordinator.swift
//  Five
//
//  Created by Mark Wong on 19/8/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class StatsCoordinator: NSObject, Coordinator, UINavigationControllerDelegate, CleanupProtocol {
    
    weak var parentCoordinator: SettingsCoordinator?
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    	
	init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // stats viewcontroller begin here
    func start(_ persistentContainer: PersistentContainer?) {
        navigationController.delegate = self
        guard let persistentContainer = persistentContainer else {
            return
        }
        let vc = StatsViewController(persistentContainer: persistentContainer, coordinator: self, viewModel: StatsViewModel())
		navigationController.pushViewController(vc, animated: true)
    }
	
	func dismiss() {
		// check
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
	
    func getTopMostViewController() -> UIViewController? {
		var topMostViewController = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        return topMostViewController
    }
    
	func cleanUpChildCoordinator() {
		NotificationCenter.default.post(name: Notification.Name(SettingsNavigationObserverKey.ReturnFromStats.rawValue), object: self)
	}
}
