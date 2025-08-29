//
//  SettingsViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 3/8/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    
    private var viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UICollectionViewLayout().createCollectionViewSectionHeaderLayout(itemSpace: .init(top: 0, leading: 5, bottom: 0, trailing: 5), groupSpacing: .zero)) }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.configureDatasource(view: collectionView)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let selectedItem = viewModel.diffableDatasource.itemIdentifier(for: indexPath) {
			selectedItem.performAction?()
		}
    }
}

