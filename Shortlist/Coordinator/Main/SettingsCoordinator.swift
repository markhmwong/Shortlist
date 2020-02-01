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
    
	typealias DeletionClosure = () -> ()
	
	var rootViewController: SettingsViewController? = nil
	
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
		rootViewController = vc
        let nav = UINavigationController(rootViewController: vc)
        navigationController.present(nav, animated: true, completion: nil)
    }
    
    // add stats view and coordinator
    func showTaskLimit(_ persistentContainer: PersistentContainer?) {
		let child = TaskLimitCoordinator(navigationController: navigationController, parentViewController: rootViewController ?? nil)
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
	
	func deleteBox(_ delegate: SettingsViewController, deletionClosure: @escaping DeletionClosure, title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
			deletionClosure()
		}
		
		let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
			self.dimiss()
		}
		alert.addAction(cancel)
		alert.addAction(delete)
		
		DispatchQueue.main.async {
            self.getTopMostViewController()?.present(alert, animated: true, completion: nil)
        }
	}
	
	func dimiss() {
		let topMostVc = getTopMostViewController()
		topMostVc?.dismiss(animated: true, completion: {
			//
		})
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
