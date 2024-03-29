//
//  ContactCoordinator.swift
//  Five
//
//  Created by Mark Wong on 7/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AboutCoordinator: NSObject, Coordinator, UINavigationControllerDelegate, CleanupProtocol {
    func dismissCurrentView() {
        
    }
    weak var parentCoordinator: SettingsCoordinator?
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
	// Absolute root nav controller
    var navigationController: UINavigationController
    	
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // stats viewcontroller begin here
	func start(_ persistentContainer: PersistentContainer?) {
        navigationController.delegate = self
        let vc = AboutViewController(coordinator: self)
		navigationController.pushViewController(vc, animated: true)
    }
	
	func dismiss() {
		navigationController.popViewController(animated: true)
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
		NotificationCenter.default.post(name: Notification.Name(SettingsNavigationObserverKey.ReturnFromInfo.rawValue), object: self)
	}
}
