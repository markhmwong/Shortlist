//
//  SettingsViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 3/8/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

enum SettingsCellType {
	/// Label type cell with no interactivity other than the instrinsic touch to push/present a new view
    case label
	/// Cell with a slider. Should not present/push a new view
    case slider
    
}

struct SettingsItem: Hashable {
    var name: String
    var section: SettingsViewModel.SettingsSection
    var value: String?
    var itemType: SettingsCellType
    
}

class SettingsViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    
    private var viewModel: SettingsViewModel
    
    private var coordinator: SettingsCoordinator
    
    init(viewModel: SettingsViewModel, coordinator: SettingsCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(collectionViewLayout: UICollectionViewLayout().createCollectionViewSectionHeaderLayout(itemSpace: .init(top: 0, leading: 5, bottom: 0, trailing: 5), groupSpacing: .zero)) }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.configureDatasource(view: collectionView)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            
        }
    }
}
