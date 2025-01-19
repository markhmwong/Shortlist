//
//  SettingsCell.swift
//  Shortlist
//
//  Created by Mark Wong on 4/8/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit
import WhizUtilKit

class SettingsCell: BaseCollectionViewCell<AnySettingsItem> {
    public var _item: AnySettingsItem? {
        set {
            item = newValue
            titleLabel.text = item?.title
			if let baseItem = item?.baseItem as? GeneralSettingsItem {
				titleLabel.font = baseItem.font
			}

        }
        get {
            return item
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "placeholder"
        label.font = UIFont.preferredFont(forTextStyle: .body).withWeight(.bold)
        label.textColor = .defaultText
        label.backgroundColor = .clear
        label.isUserInteractionEnabled = false
        return label
    }()

    override func setupViewsIfNeeded() {
        super.setupViewsIfNeeded()
        contentView.layer.cornerRadius = 5.0
        
        /// layout
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
        ])
    }
 
    /// Configure Cell
    /// - Parameter item: the model that is passed to fill out contents of the cell
    public override func configureCell(with item: AnySettingsItem) {
        super.configureCell(with: item)
        // configure item in the setter for _item
        _item = item

    }

}

