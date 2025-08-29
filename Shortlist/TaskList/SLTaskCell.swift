//
//  SLTaskCell.swift
//  Shortlist
//
//  Created by Mark Wong on 14/4/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit
import WhizUtilKit

extension UIFont {
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        UIFont.systemFont(ofSize: pointSize, weight: weight)
    }
}

class SLTaskCell: BaseCollectionViewCell<SLTask> {
    
    var _item: SLTask? {
        set {
            item = newValue
            titleLabel.text = item?.name
            if let status = TaskStatus(rawValue: item?.taskToStatus?.name ?? "Incomplete") {
                completeLabel.text = status.rawValue
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
        label.font = UIFont.preferredFont(forTextStyle: .body).withWeight(.bold)
		label.textColor = .defaultText
        label.backgroundColor = .clear
        label.isEditable = false
		label.isUserInteractionEnabled = false
        label.isScrollEnabled = false
        return label
    }()
    
    lazy var completeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "complete"
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .defaultText
        return label
    }()
    
    override func setupViewsIfNeeded() {
		super.setupViewsIfNeeded()
        contentView.layer.cornerRadius = 5.0
		contentView.layer.borderWidth = 2.0

        /// layout
        contentView.addSubview(titleLabel)
        contentView.addSubview(completeLabel)
        
        NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),

            completeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            completeLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            completeLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
        ])
    }
    
    /// Configure Cell
    /// - Parameter item: the model that is passed to fill out contents of the cell
    override func configureCell(with item: SLTask) {
        super.configureCell(with: item)
        // configure item in the setter for _item
        _item = item

		priorityLevelColour()
    }

	private func priorityLevelColour() {
		/// configure cell ui
		if let pl = TaskPriorityLevel(rawValue: Int(_item?.priority ?? 2)) {
			let colors = calculateColors(for: pl)
			contentView.backgroundColor = colors.backgroundColor
			titleLabel.textColor = colors.textColor
			completeLabel.textColor = colors.textColor
			contentView.layer.borderColor = colors.backgroundColor.darker(by: 3.0)?.cgColor
		} else {
			contentView.backgroundColor = UIColor.lightGray
			titleLabel.textColor = UIColor.darkText
			completeLabel.textColor = UIColor.darkText
		}
	}

    private func calculateColors(for priority: TaskPriorityLevel) -> (textColor: UIColor, backgroundColor: UIColor, borderColor: UIColor) {
        let baseColour = priority.baseColour
		let textColour = priority.textColour
        let backgroundColor = baseColour.lighter(by: 20.0) ?? baseColour
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

