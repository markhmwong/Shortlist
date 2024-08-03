//
//  SettingsViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 3/8/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

class SettingsViewModel {
    init() {
        
    }
}

class SettingsCoordinator: CoordinatorFacade {
    
}

class SettingsViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    
    private var viewModel: SettingsViewModel
    
    private var coordinator: SettingsCoordinator
    
    init(viewModel: SettingsViewModel, coordinator: SettingsCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(collectionViewLayout: UICollectionViewLayout().createCollectionViewSectionHeaderLayout(itemSpace: .init(top: 0, leading: 5, bottom: 0, trailing: 5), groupSpacing: .zero))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
