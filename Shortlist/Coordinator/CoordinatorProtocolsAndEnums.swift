//
//  Coordinator.swift
//  Five
//
//  Created by Mark Wong on 19/8/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

enum NavigationObserverKey: String {
	case ReturnFromSettings = "Settings"
	case ReturnFromPreplan = "Preplan"
}

protocol MainCoordinatorProtocol { }

protocol ObserverProtocol {
	func addNavigationObserver(_ observerKey: NavigationObserverKey)
}

protocol CleanupProtocol {
	func cleanUpChildCoordinator()
}

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
	// add getTopMostViewController
	
    func start(_ persistentContainer: PersistentContainer?)
}
