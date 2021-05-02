//
//  ReviewCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 17/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class ReviewCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    func dismissCurrentView() {
        
    }
    weak var parentCoordinator: MainCoordinator?
    
	weak var parentCoordinatorFromSettings: SettingsCoordinator?
	
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
//	weak var mainViewController: MainViewController? = nil
	
	// Used to determine whether the app will update the global task count
	private var automatedUpdateTaskCount: Bool = false
	
	init(navigationController: UINavigationController, automated: Bool) {
		self.navigationController = navigationController
		self.automatedUpdateTaskCount = automated
	}
	
	init(navigationController:UINavigationController, mainViewController: MainViewController?, automated: Bool) {
        self.navigationController = navigationController
//		self.mainViewController = mainViewController
		self.automatedUpdateTaskCount = automated
    }
    
    // stats viewcontroller begins here
    func start(_ persistentContainer: PersistentContainer?) {
		// to do add persistent container
		let vc = ReviewCollectionListViewController(viewModel: ReviewCollectionListViewModel())
//		navigationController.pushViewController(vc, animated: true, completion: nil)
		navigationController.pushViewController(vc, animated: true)
//        navigationController.delegate = self
//        guard let persistentContainer = persistentContainer else {
//            print("Persistent Container not loaded")
//            return
//        }
//        let viewModel = ReviewViewModel()
//        let vc = ReviewViewController(persistentContainer: persistentContainer, coordinator: self, viewModel: viewModel, automatedDisplay: automatedUpdateTaskCount)
//		vc.onDoneBlock = { [weak self] in
////			guard let self = self else { return }
//			// reload global tally text
////			let amount = self.mainViewController?.load
////			self.mainViewController?.loadFirebaseData()
//		}
//		navigationController.modalPresentationStyle = .fullScreen
//		navigationController.present(vc, animated: true, completion: nil)
    }
	
	func dimissFromMainViewController(_ persistentContainer: PersistentContainer?) {
		//get mainviewcontroller delegate
		
		navigationController.dismiss(animated: true) {
//			guard let mvc = self.mainViewController else {
//				return
//			}
//			mvc.loadData()
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
    
	func cleanUpChildCoordinator() {
		NotificationCenter.default.post(name: Notification.Name(MainNavigationObserverKey.ReturnFromReview.rawValue), object: self)
	}
}

