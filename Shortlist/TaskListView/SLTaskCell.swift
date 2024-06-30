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
            if let status = TaskStatus(rawValue: item?.taskToStatus?.name ?? "Incomplete") {
                completeLabel.text = status.rawValue
                print(completeLabel.text)
            }
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
    
    lazy var completeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "complete"
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .defaultText
        return label
    }()
    
    override func setupViewsIfNeeded() {
		super.setupViewsIfNeeded()
		
		
        /// layout
        contentView.addSubview(titleLabel)
        contentView.addSubview(completeLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            completeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            completeLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
        ])
        
        contentView.layer.cornerRadius = 5.0
    }
    
    /// Configure Cell
    /// - Parameter item: the model that is passed to fill out contents of the cell
    override func configureCell(with item: SLTask) {
        super.configureCell(with: item)
        // configure item in the setter for _item
        self._item = item

        /// configure cell ui
        if let pl = PriorityLevel(rawValue: Int(self._item?.priority ?? 2)) {
            let colors = calculateColors(for: pl)
            contentView.backgroundColor = colors.backgroundColor
            contentView.layer.borderColor = colors.borderColor.cgColor
            contentView.layer.borderWidth = 2.0
            titleLabel.textColor = colors.textColor
            completeLabel.textColor = colors.textColor
        }
    }
    
    private func calculateColors(for priority: PriorityLevel) -> (textColor: UIColor, backgroundColor: UIColor, borderColor: UIColor) {
        let baseColour = priority.baseColour
        let textColour = baseColour.darker(by: 30.0) ?? baseColour
        let backgroundColor = baseColour.lighter(by: 40.0) ?? baseColour
        let borderColour = baseColour.darker(by: 10.0) ?? baseColour
        
        return (textColour, backgroundColor, borderColour)
    }
    
	func enableEditing() {
		titleLabel.isEditable = true
		titleLabel.isUserInteractionEnabled = false
	}
    func focusText() {
        titleLabel.becomeFirstResponder()
    }
    
    func isComplete(_ status: TaskStatus) {
        guard let item = _item else { return }
        item.taskToStatus?.name = status.rawValue
        
//        switch status {
//        case .Complete:
//            item.taskToStatus?.name = status.rawValue
//        case .Incomplete:
//            item.taskToStatus?.name = TaskStatus.Complete.rawValue
//        case .Backlog, .Active:
//            ()
//        }
    }
}
