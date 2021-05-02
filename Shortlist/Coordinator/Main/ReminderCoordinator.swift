//
//  ReminderCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 2/4/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class ReminderCoordinator: NSObject, Coordinator {
    func dismissCurrentView() {
        
    }
	var childCoordinators: [Coordinator] = []
	
	var navigationController: UINavigationController
	
	var parentCoordinator: MainCoordinatorProtocol?
	
	var mainViewController: MainViewControllerProtocol
	
	var rootViewController: ReminderViewController?
	
	init(navigationController: UINavigationController, viewController: MainViewControllerProtocol) {
        self.navigationController = navigationController
		self.mainViewController = viewController
    }
	
	func start(_ persistentContainer: PersistentContainer?) {
		guard let persistentContainer = persistentContainer else { return }
		let vc = ReminderViewController(viewModel: ReminderViewModel(), reminderService: ReminderService(), persistentContainer: persistentContainer, coordinator: self)
		rootViewController = vc
		let nav = UINavigationController(rootViewController: vc)
		navigationController.present(nav, animated: true)
	}
	
	func dismiss() {
		navigationController.dismiss(animated: true) {
			//
		}
	}
	
	func showAlertBox(message: String) {
        let alert = UIAlertController(title: "Wait a moment..", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		DispatchQueue.main.async {
			self.rootViewController?.present(alert, animated: true, completion: nil)
        }
	}
	
}
