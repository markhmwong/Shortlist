//
//  OnboardingCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 7/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class OnboardingCoordinator: NSObject, Coordinator, UINavigationControllerDelegate, CleanupProtocol {
	
    var parentCoordinator: MainCoordinatorProtocol?
	
	var childCoordinators: [Coordinator] = [Coordinator]()
	
    var navigationController: UINavigationController

	var mainViewController: MainViewControllerProtocol
	
    init(navigationController: UINavigationController, viewController: MainViewControllerProtocol) {
        self.navigationController = navigationController
		self.mainViewController = viewController
    }
    
    // begin application
    func start(_ persistentContainer: PersistentContainer?) {
        navigationController.delegate = self
        let viewModel = OnboardingViewModel()
        let vc = OnboardingViewController(viewModel: viewModel)
		vc.coordinator = self
        let nav = UINavigationController(rootViewController: vc)

		DispatchQueue.main.async {
			nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
			nav.navigationBar.shadowImage = UIImage()
			nav.navigationBar.isTranslucent = true
			nav.navigationBar.isHidden = true
			self.navigationController.present(nav, animated: false, completion: nil)
		}
    }
	
	func dismiss(_ persistentContainer: PersistentContainer?) {
		//get mainviewcontroller delegate
		navigationController.dismiss(animated: true) {
			
		}
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
	
	func cleanUpChildCoordinator() {
		NotificationCenter.default.post(name: Notification.Name(MainNavigationObserverKey.ReturnFromOnboarding.rawValue), object: self)
	}
}
