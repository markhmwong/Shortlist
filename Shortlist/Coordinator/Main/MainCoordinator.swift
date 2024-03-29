//
//  MainCoordinator.swift
//  Five
//
//  Created by Mark Wong on 19/8/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate, MainCoordinatorProtocol, ObserverChildCoordinatorsProtocol {
    
    func dismissCurrentView() {
        
    }
    
	var rootViewController: MainViewControllerWithCollectionView?
	
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
	var reviewFlag: Bool = false
	
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
	
    // begin application
    func start(_ persistentContainer: PersistentContainer?) {
		navigationController.delegate = self
		// Deprecated 1.2.x
//		let viewModel = MainViewModel()
//		let vc = MainViewController(persistentContainer: persistentContainer, viewModel: viewModel)
		
		// 2.0
		guard let persistentContainer = persistentContainer else { return }
		let vc = MainViewControllerWithCollectionView(viewModel: MainViewModelWithCollectionView(), persistentContainer: persistentContainer)
		vc.coordinator = self
        rootViewController = vc
		navigationController.pushViewController(vc, animated: false)
		
		navigationController.navigationBar.isHidden = false
		navigationController.navigationBar.isTranslucent = false
		navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController.navigationBar.shadowImage = UIImage()
		navigationController.navigationBar.backgroundColor = UIColor.clear
    }
	
	/*
	
		//MARK: - Navigation Methods
	
	*/
	func showTipJar() {
		let vc = TipsViewController(viewModel: TipsViewModel(), coordinator: nil)
		navigationController.present(vc, animated: true) {
			//
		}
	}
	
	func showCreateTask(_ persistentContainer: PersistentContainer?) {
		print("To do - Create Task")
		let child = NewTaskCoordinator(navigationController: navigationController)
		childCoordinators.append(child)
		child.start(persistentContainer)
	}
	
	func showOnboarding(_ persistentContainer: PersistentContainer?) {
		addNavigationObserver(MainNavigationObserverKey.ReturnFromOnboarding)
		
		guard let rvc = rootViewController else { return }
//		let child = OnboardingCoordinator(navigationController: navigationController, viewController: rvc)
//		child.parentCoordinator = self
//		childCoordinators.append(child)
//		child.start(persistentContainer)
	}
    
    // add stats view and coordinator
    func showSettings(_ persistentContainer: PersistentContainer?) {
		addNavigationObserver(MainNavigationObserverKey.ReturnFromSettings)
		
        let child = SettingsCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(persistentContainer)
    }
	
	func showPreplan(_ persistentContainer: PersistentContainer?) {
		addNavigationObserver(MainNavigationObserverKey.ReturnFromPreplan)
		
		let child = PreplanCoordinator(navigationController: navigationController)
		child.parentCoordinator = self
		childCoordinators.append(child)
		child.start(persistentContainer)
	}
	
	func showBacklog(_ persistentContainer: PersistentContainer?) {
		addNavigationObserver(MainNavigationObserverKey.ReturnFromBackLog)

        let child = BackLogCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(persistentContainer)
	}
    
	func showReview(_ persistentContainer: PersistentContainer?, automated: Bool) {
		let child = ReviewCoordinator(navigationController: navigationController, automated: automated)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(persistentContainer)
    }
	
	func showEditTask(_ persistentContainer: PersistentContainer?, task: Task, fetchedResultsController: NSFetchedResultsController<Day>, mainViewController: MainViewControllerProtocol) {
		addNavigationObserver(MainNavigationObserverKey.ReturnFromEditing)
		let child = EditTaskCoordinator(navigationController: navigationController)
		child.parentCoordinator = self
		child.task = task
		child.fetchedResultsController = fetchedResultsController
		child.mainViewController = mainViewController
        childCoordinators.append(child)
        child.start(persistentContainer)
	}
	
	// Additional Options
	func showOptions(_ persistentContainer: PersistentContainer?) {
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

		alert.addAction(UIAlertAction(title: "Add Task from Reminders", style: .default) { _ in
			self.showReminders(persistentContainer: persistentContainer)
		})
		
		alert.addAction(UIAlertAction(title: "Preplan", style: .default) { _ in
			self.showPreplan(persistentContainer)
		})

		alert.addAction(UIAlertAction(title: "Backlog", style: .default) { _ in
			self.showBacklog(persistentContainer)
		})
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
			
		})

		navigationController.present(alert, animated: true)
	}
	
	func showTaskDetails(with item: Task, persistentContainer: PersistentContainer?) {
		let taskCoordinator = TaskDetailCoordinator(navigationController: navigationController , task: item)
		taskCoordinator.start(persistentContainer)
	}
	
	func showReminders(persistentContainer: PersistentContainer?) {
		addNavigationObserver(MainNavigationObserverKey.ReturnFromReminders)
		guard let rootViewController = rootViewController else { return }
//		let child = ReminderCoordinator(navigationController: navigationController, viewController: rootViewController)
//		child.parentCoordinator = self
//		childCoordinators.append(child)
//		child.start(persistentContainer)
	}
    
    func showAlertBox(_ message: String) {
        let alert = UIAlertController(title: "Hold up!", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		DispatchQueue.main.async {
			self.getTopMostViewController()?.present(alert, animated: true, completion: nil)
        }
    }
	
	func showCategory(_ persistentContainer: PersistentContainer?, mainViewController: MainViewController) {
		addNavigationObserver(MainNavigationObserverKey.ReturnFromCategorySelection)

		let child = SelectCategoryCoordinator(navigationController: navigationController, viewController: mainViewController)
		child.parentCoordinator = self
		childCoordinators.append(child)
		child.start(persistentContainer)
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
        
        if let statsViewController = fromViewController as? StatsViewController {
            childDidFinish(statsViewController.coordinator!)
        }
    }
	
	func addNavigationObserver(_ observerKey: ObserveNavigation) {
		if let key = observerKey as? MainNavigationObserverKey {
			NotificationCenter.default.addObserver(self, selector: #selector(handleViewControllerDidAppear), name: Notification.Name(rawValue: key.rawValue), object: nil)
		}
	}
	
	func removeNavigationObserver(_ observerKey: ObserveNavigation) {
		if let key = observerKey as? MainNavigationObserverKey {
			NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: key.rawValue), object: nil)
		}
	}
	
	func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
		//
	}
	
	// in the event that the main viewcontroller is the main focus
	@objc func handleViewControllerDidAppear(_ notification: Notification) {
		if let n = MainNavigationObserverKey.init(rawValue: notification.name.rawValue) {
			removeNavigationObserver(n)
			switch n {
				case .ReturnFromSettings:
					// may be use dict to identify which coordinator
					if let c = notification.object as? SettingsCoordinator {
						childDidFinish(c)
					}
				case .ReturnFromPreplan:
					if let c = notification.object as? PreplanCoordinator {
						childDidFinish(c)
					}
				case .ReturnFromBackLog:
					if let c = notification.object as? BackLogCoordinator {
						childDidFinish(c)
					}
				case .ReturnFromReview:
					if let c = notification.object as? ReviewCoordinator {
						childDidFinish(c)
					}
				case .ReturnFromEditing:
					if let c = notification.object as? EditTaskCoordinator {
						childDidFinish(c)
					}
				case .ReturnFromCategorySelection:
					if let c = notification.object as? CategoryTasksCoordinator {
						childDidFinish(c)
					}
				case .ReturnFromOnboarding:
					if let c = notification.object as? OnboardingCoordinator {
						childDidFinish(c)
					}
				case .ReturnFromReminders:
					if let c = notification.object as? ReminderCoordinator {
						childDidFinish(c)
					}
			}
		}
	}
}
