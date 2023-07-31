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
	
//	weak var rootViewController: SettingsViewController? = nil
	
    weak var parentCoordinator: MainCoordinator?
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
	var settingsNavController: UINavigationController?
	
    var day: Day! = nil
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // stats viewcontroller begin here
    func start(_ persistentContainer: PersistentContainer?) {
        guard let _persistentContainer = persistentContainer else {
			fatalError("Persistent Container Nil")
        }
        navigationController.delegate = self

		// Shortlist 2.0 new Settings View
		let vc = SettingsListViewController(viewModel: SettingsListViewModel(persistentContainer: _persistentContainer, coordinator: self), persistentContainer: _persistentContainer, coordinator: self) // add persistent container
		vc.navigationItem.title = "Settings"
		settingsNavController = UINavigationController(rootViewController: vc)
		
		if let nav = settingsNavController {
			navigationController.present(nav, animated: true) {
				//
			}
		}
		
		// Shortlist 1.x.x OLD VIEW CONTROLLER
//		let vm = SettingsViewModel()
//		let vc = SettingsViewController(persistentContainer: _persistentContainer, coordinator: self, viewModel: vm)
//		rootViewController = vc
//        let nav = UINavigationController(rootViewController: vc)
//        navigationController.present(nav, animated: true, completion: nil)
    }
	
	func showTipJar() {
		if let nav = settingsNavController {
			let vc = TipsViewController(viewModel: TipsViewModel(), coordinator: nil)
			nav.pushViewController(vc, animated: true)
		}
	}
	
	func showPermissions() {
		if let nav = settingsNavController {
			let viewModel = PermissionsViewModel(privacyPermissions: PrivacyPermissionsService())
			let vc = PermissionsViewController(viewModel: viewModel)
			nav.pushViewController(vc, animated: true)
		}
	}
    
    // add stats view and coordinator
	func showTaskLimit(_ persistentContainer: PersistentContainer?, item: SettingsListItem) {
		addNavigationObserver(SettingsNavigationObserverKey.ReturnFromPriorityLimit)

		guard let persistentContainer = persistentContainer else { return }
		let vc = PriorityLimitViewController(item: item, viewModel: PriorityLimitViewModel(persistentContainer: persistentContainer, data: day))
		
		if let nav = settingsNavController {
			nav.pushViewController(vc, animated: true)
		}
    }
    
    // add contact view
    func showAbout(_ persistentContainer: PersistentContainer?) {
		addNavigationObserver(SettingsNavigationObserverKey.ReturnFromInfo)
		if let nav = settingsNavController {
			let vc = AboutViewController()
			nav.pushViewController(vc, animated: true)
		}
    }
	
	func showWhatsNew() {
		if let nav = settingsNavController {
			let vc = WhatsNewViewController(viewModel: WhatsNewViewModel())
			nav.pushViewController(vc, animated: true)
		}
	}
	
	func showPrivacy() {
		if let nav = settingsNavController {
			let vc = PrivacyViewController()
			nav.pushViewController(vc, animated: true)
		}
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
	
	func showReview(_ persistentContainer: PersistentContainer?, automated: Bool) {
//		addNavigationObserver(MainNavigationObserverKey.ReturnFromReview)
		guard let navController = settingsNavController else { return }
		let child = ReviewCoordinator(navigationController: navController, automated: automated)
		childCoordinators.append(child)
		child.start(persistentContainer)
	}
	
    // add stats view and coordinator
    func showStats(_ persistentContainer: PersistentContainer?) {
		guard let navController = settingsNavController else { return }

		addNavigationObserver(SettingsNavigationObserverKey.ReturnFromStats)
		let child = StatsCoordinator(navigationController: navController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(persistentContainer)
    }
	
	func deleteBox(deletionClosure: @escaping DeletionClosure, title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
			deletionClosure()
		}
		
		let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
			self.dismissCurrentView()
		}
		alert.addAction(cancel)
		alert.addAction(delete)
		
		DispatchQueue.main.async {
            self.getTopMostViewController()?.present(alert, animated: true, completion: nil)
        }
	}
	
	func dismissCurrentView() {
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

	}

}
