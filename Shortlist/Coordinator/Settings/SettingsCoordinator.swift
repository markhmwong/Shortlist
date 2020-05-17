//
//  SettingsCoordinator.swift
//  Five
//
//  Created by Mark Wong on 4/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import MessageUI

class SettingsCoordinator: NSObject, Coordinator, UINavigationControllerDelegate, CleanupProtocol, ObserverChildCoordinatorsProtocol {
    
	typealias DeletionClosure = () -> ()
	
	weak var rootViewController: SettingsViewController? = nil
	
    weak var parentCoordinator: MainCoordinator?
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }

    // stats viewcontroller begin here
    func start(_ persistentContainer: PersistentContainer?) {
        guard let _persistentContainer = persistentContainer else {
            return
        }
        navigationController.delegate = self

		let vm = SettingsViewModel()
		let vc = SettingsViewController(persistentContainer: _persistentContainer, coordinator: self, viewModel: vm)
		rootViewController = vc
        let nav = UINavigationController(rootViewController: vc)
        navigationController.present(nav, animated: true, completion: nil)
    }
    
    // add stats view and coordinator
    func showTaskLimit(_ persistentContainer: PersistentContainer?) {
		addNavigationObserver(SettingsNavigationObserverKey.ReturnFromPriorityLimit)

		let child = TaskLimitCoordinator(navigationController: navigationController, parentViewController: rootViewController ?? nil)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(persistentContainer)
    }
    
    // add contact view
    func showAbout(_ persistentContainer: PersistentContainer?) {
		addNavigationObserver(SettingsNavigationObserverKey.ReturnFromInfo)

		let child = AboutCoordinator(navigationController: navigationController, parentViewController: rootViewController ?? nil)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(persistentContainer)
    }
	
    func showAlertBox(_ message: String) {
        let alert = UIAlertController(title: "Hold up!", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		DispatchQueue.main.async {
			self.getTopMostViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    func showFeedback(_ viewController: MFMailComposeViewController) {
        DispatchQueue.main.async {
            self.getTopMostViewController()?.present(viewController, animated: true, completion: nil)
        }
    }
	
    // add stats view and coordinator
    func showStats(_ persistentContainer: PersistentContainer?) {
		addNavigationObserver(SettingsNavigationObserverKey.ReturnFromStats)
		let child = StatsCoordinator(navigationController: navigationController, parentViewController: rootViewController ?? nil)
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
		navigationController.dismiss(animated: true) {
			
		}
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
	
	func addNavigationObserver(_ observerKey: ObserveNavigation) {
		if let key = observerKey as? SettingsNavigationObserverKey {
			NotificationCenter.default.addObserver(self, selector: #selector(handleViewControllerDidAppear), name: Notification.Name(rawValue: key.rawValue), object: nil)
		}
	}
	
	func removeNavigationObserver(_ observerKey: ObserveNavigation) {
		if let key = observerKey as? SettingsNavigationObserverKey {
			NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: key.rawValue), object: nil)
		}
	}
	
	func cleanUpChildCoordinator() {
		NotificationCenter.default.post(name: Notification.Name(MainNavigationObserverKey.ReturnFromSettings.rawValue), object: self)
	}

	// in the event that the main viewcontroller is the main focus
	@objc func handleViewControllerDidAppear(_ notification: Notification) {
		if let n = SettingsNavigationObserverKey.init(rawValue: notification.name.rawValue) {
			removeNavigationObserver(n)
			switch n {
				case .ReturnFromStats:
					// may be use dict to identify which coordinator
					if let c = notification.object as? StatsCoordinator {
						childDidFinish(c)
					}
				case .ReturnFromInfo:
					if let c = notification.object as? AboutCoordinator {
						childDidFinish(c)
					}
				case .ReturnFromPriorityLimit:
					if let c = notification.object as? TaskLimitCoordinator {
						childDidFinish(c)
					}
			}
		}
	}

}
