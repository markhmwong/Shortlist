//
//  Coordinator.swift
//  Five
//
//  Created by Mark Wong on 19/8/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start(_ persistentContainer: PersistentContainer?)
}
