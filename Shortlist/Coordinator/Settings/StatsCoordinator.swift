//
//  StatsCoordinator.swift
//  Five
//
//  Created by Mark Wong on 19/8/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class StatsCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    weak var parentCoordinator: SettingsCoordinator?
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
	weak var parentViewController: SettingsViewController? = nil
	
	init(navigationController: UINavigationController, parentViewController: SettingsViewController?) {
        self.navigationController = navigationController
		self.parentViewController = parentViewController
    }
    
    // stats viewcontroller begin here
    func start(_ persistentContainer: PersistentContainer?) {
        navigationController.delegate = self
        guard let persistentContainer = persistentContainer else {
            print("Persistent Container not loaded")
            return
        }
        let vc = StatsViewController(persistentContainer: persistentContainer, coordinator: self, viewModel: StatsViewModel())
		parentViewController?.navigationController?.pushViewController(vc, animated: true)

//		DispatchQueue.main.async {
//			self.getTopMostViewController()?.navigationController?.pushViewController(vc, animated: true)
//		}
		
		
//        let nav = UINavigationController(rootViewController: vc)
//        DispatchQueue.main.async {
//            self.getTopMostViewController()?.present(nav, animated: true, completion: nil)
//        }
    }
	
	func dismiss() {
		parentViewController?.navigationController?.popViewController(animated: true)
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
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
    }
}
