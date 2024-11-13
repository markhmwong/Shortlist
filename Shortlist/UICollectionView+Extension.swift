//
//  UICollectionViewCell+Extension.swift
//  Shortlist
//
//  Created by Mark Wong on 13/4/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

extension UICollectionView.CellRegistration {
    
    static func registerTaskCell() -> UICollectionView.CellRegistration<SLTaskCell, SLTask> {
        let cellConfig = UICollectionView.CellRegistration<SLTaskCell, SLTask> { (cell, indexPath, item) in
            cell.configureCell(with: item)
        }
        return cellConfig
    }
    
    static func registerSettingsCell() -> UICollectionView.CellRegistration<SettingsCell, SettingsItem> {
        let cellConfig = UICollectionView.CellRegistration<SettingsCell, SettingsItem> { (cell, indexPath, item) in
            cell.configureCell(with: item)
        }
        return cellConfig
    }

	static func registerSliderSettingsCell() -> UICollectionView.CellRegistration<SliderSettingsCell, SettingsItem> {
		let cellConfig = UICollectionView.CellRegistration<SliderSettingsCell, SettingsItem> { (cell, indexPath, item) in
			cell.configureCell(with: item)
		}
		return cellConfig
	}
}
