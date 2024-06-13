//
//  Coordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 9/6/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

protocol Coordinator {
    var rootViewController: UIViewController? { get }
    
    var rootNavigationController: UINavigationController? { get }
    
    var parentCoordinator: Coordinator? { get }
    
    var parentNavigationController: UINavigationController? { get }
    
    var coreDataStack: CoreDataStack? { get }
    
    func start()
    
    func dismissEntireStack()
    
    func dismissCurrentView()
}
