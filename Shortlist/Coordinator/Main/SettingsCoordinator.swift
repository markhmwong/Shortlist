//
//  SettingsCoordinator.swift
//  Five
//
//  Created by Mark Wong on 4/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import MessageUI

class SettingsCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    weak var parentCoordinator: MainCoordinator?
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }

    // stats viewcontroller begin here
    func start(_ persistentContainer: PersistentContainer?) {
        navigationController.delegate = self
        guard let persistentContainer = persistentContainer else {
            print("Persistent Container not loaded")
            return
        }
		
		let vm = SettingsViewModel()
		let vc = SettingsViewController(persistentContainer: persistentContainer, coordinator: self, viewModel: vm)
        let nav = UINavigationController(rootViewController: vc)
        navigationController.present(nav, animated: true, completion: nil)
    }
    
    // add stats view and coordinator
    func showTaskLimit(_ persistentContainer: PersistentContainer?) {
        let child = TaskLimitCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(persistentContainer)
    }
    
    // add contact view
    func showAbout(_ persistentContainer: PersistentContainer?) {
        let child = AboutCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(persistentContainer)
    }
    
    func showFeedback(_ viewController: MFMailComposeViewController) {
        DispatchQueue.main.async {
            self.getTopMostViewController()?.present(viewController, animated: true, completion: nil)
        }
    }
	
    // add stats view and coordinator
    func showStats(_ persistentContainer: PersistentContainer?) {
        let child = StatsCoordinator(navigationController: navigationController)
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
        
    }
}
