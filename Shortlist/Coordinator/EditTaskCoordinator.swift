//
//  EditTaskCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 22/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class EditTaskCoordinator: NSObject, Coordinator, UINavigationControllerDelegate, CleanupProtocol {
    
    weak var parentCoordinator: MainCoordinator?
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
	var task: Task?
	
	var fetchedResultsController: NSFetchedResultsController<Day>?
	
	var mainViewController: MainViewControllerProtocol?
	
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
		let viewModel = EditTaskViewModel(with: task)
		let vc = EditTaskViewController(viewModel: viewModel, persistentContainer: persistentContainer, fetchedResultsController: fetchedResultsController!, delegate: mainViewController!, coordinator: self)
        let nav = UINavigationController(rootViewController: vc)
        navigationController.present(nav, animated: true, completion: nil)
    }
	
	func discardBox(viewModel: EditTaskViewModel, persistentContainer: PersistentContainer?) {
		let alert = UIAlertController(title: "Are you sure you want to discard any changes?", message: "", preferredStyle: .alert)
		let keepEditing = UIAlertAction(title: "Keep Editing", style: .default) { (action) in
			//
		}
		
		let discard = UIAlertAction(title: "Discard", style: .cancel) { (action) in
			self.dimiss()
		}
		alert.addAction(discard)
		alert.addAction(keepEditing)

		DispatchQueue.main.async {
			self.getTopMostViewController()?.present(alert, animated: true, completion: nil)
		}
	}
	
	func dimiss() {
		 getTopMostViewController()?.dismiss(animated: true, completion: {
			 //
		 })
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
	
	func cleanUpChildCoordinator() {
		NotificationCenter.default.post(name: Notification.Name(MainNavigationObserverKey.ReturnFromEditing.rawValue), object: self)
	}
}
