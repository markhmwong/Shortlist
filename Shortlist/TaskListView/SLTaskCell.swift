//
//  SLTaskCell.swift
//  Shortlist
//
//  Created by Mark Wong on 14/4/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit
import WhizUtilKit

class SLTaskCell: BaseCollectionViewCell<SLTask> {
    
    var _item: SLTask? {
        set {
            item = newValue
        }
        get {
            return item
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "placeholder"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .black
        return label
    }()
    
    /// Configure Cell
    /// - Parameter item: the model that is passed to fill out contents of the cell
    override func configureCell(with item: SLTask) {
        super.configureCell(with: item)
        
        /// layout
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        /// fill content
        titleLabel.text = item.name
        
        item.createdAt
    }
    
}
