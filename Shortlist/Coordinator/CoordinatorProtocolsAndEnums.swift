//
//  Coordinator.swift
//  Five
//
//  Created by Mark Wong on 19/8/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

protocol MainCoordinatorProtocol { }
protocol ObserveNavigation { }

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
	// add getTopMostViewController
	
    func start(_ persistentContainer: PersistentContainer?)
}

// Key to identify which coordinator was recently closed
enum MainNavigationObserverKey: String, ObserveNavigation {
	case ReturnFromSettings = "Settings"
	case ReturnFromPreplan = "Preplan"
	case ReturnFromBackLog = "BackLog"
	case ReturnFromReview = "Review"
	case ReturnFromEditing = "Edit"
	case ReturnFromOnboarding = "Onboarding"
	case ReturnFromCategorySelection = "Category"
}

enum SettingsNavigationObserverKey: String, ObserveNavigation {
	case ReturnFromPriorityLimit = "Priority"
	case ReturnFromStats = "Stats"
	case ReturnFromInfo = "Info"
	// Review is missing because we dismiss the settings view controller anyway
}

// memory management of KVO within Coordinators
protocol ObserverChildCoordinatorsProtocol {
	
	// adds an observer for that coordinator
	func addNavigationObserver(_ observerKey: ObserveNavigation)
	
	// removes the observer for that specific coordinator
	func removeNavigationObserver(_ observerKey: ObserveNavigation)
}

// CleanupProtocol aids by inserting an observer that triggers the function cleanUpChildCoordinator() in the MainCoordinator which removes any instance of a coordinator lingering after it has been dismissed
protocol CleanupProtocol {
	func cleanUpChildCoordinator()
}


