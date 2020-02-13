//
//  ReviewCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 17/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class ReviewCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    weak var parentCoordinator: MainCoordinator?
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
	weak var mainViewController: MainViewController? = nil
	
	// also used to determine whether the app will update the global count
	private var automated: Bool = false
	
	init(navigationController:UINavigationController, mainViewController: MainViewController?, automated: Bool) {
        self.navigationController = navigationController
		self.mainViewController = mainViewController
		self.automated = automated
    }
	
	func cleanUpChildCoordinator() {
		NotificationCenter.default.post(name: Notification.Name(NavigationObserverKey.ReturnFromReview.rawValue), object: self)
	}
    
    // stats viewcontroller begins here
    func start(_ persistentContainer: PersistentContainer?) {
        navigationController.delegate = self
        guard let persistentContainer = persistentContainer else {
            print("Persistent Container not loaded")
            return
        }
        let viewModel = ReviewViewModel()
        let vc = ReviewViewController(persistentContainer: persistentContainer, coordinator: self, viewModel: viewModel, automatedDisplay: automated)
		navigationController.modalPresentationStyle = .fullScreen
		navigationController.present(vc, animated: true, completion: nil)
    }
	
	func dimissFromMainViewController(_ persistentContainer: PersistentContainer?) {
		//get mainviewcontroller delegate
		
		navigationController.dismiss(animated: true) {
			guard let mvc = self.mainViewController else {
				return
			}
			mvc.loadData()
		}
	}
	
	func showAlertBox(_ message: String) {
		let alert = UIAlertController(title: "Hold up!", message: "\(message)", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
	//        navigationController.present(alert, animated: true, completion: nil)
		DispatchQueue.main.async {
			self.getTopMostViewController()?.present(alert, animated: true, completion: nil)
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
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
    }
}

