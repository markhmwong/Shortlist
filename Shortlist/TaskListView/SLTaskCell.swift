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
            titleLabel.text = item?.name
        }
        get {
            return item
        }
    }
    
    lazy var titleLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "placeholder"
        label.font = UIFont.preferredFont(forTextStyle: .body)
		label.textColor = .defaultText
        label.backgroundColor = .clear
        label.isEditable = false
		label.isUserInteractionEnabled = false
        return label
    }()
    
    override func setupViewsIfNeeded() {
		super.setupViewsIfNeeded()
		
		
        /// layout
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        /// fill content
    }
    
    /// Configure Cell
    /// - Parameter item: the model that is passed to fill out contents of the cell
    override func configureCell(with item: SLTask) {
        super.configureCell(with: item)
        self._item = item

    }
    
	func enableEditing() {
		titleLabel.isEditable = true
		titleLabel.isUserInteractionEnabled = false
	}
    func focusText() {
        titleLabel.becomeFirstResponder()
    }
}
