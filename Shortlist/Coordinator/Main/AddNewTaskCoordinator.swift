//
//  AddNewTaskCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 23/3/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit

class AddNewTaskCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    // main view controller is passed here to update the main screen when the category is selected
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    // nav stack methods
    func start(_ persistentContainer: PersistentContainer?) {
        guard let pc = persistentContainer else {
            fatalError("TaskOptionsCoordinator: Cannot load Persistent Container")
        }
        let vc = AddNewTaskViewController(viewModel: AddNewTaskViewModel(persistentContainer: pc))
        navigationController.present(vc, animated: false) {
            //
        }
    }
    
    func dismissCurrentView() {
        navigationController.popViewController(animated: true)
    }

}

class AddNewTaskViewModel: NSObject {
    
    private var persistentContainer: PersistentContainer
    
    init(persistentContainer: PersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    
}

class AddNewTaskViewController: UIViewController {
    
    private var viewModel: AddNewTaskViewModel
    
    init(viewModel: AddNewTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
