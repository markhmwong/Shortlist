//
//  ReminderCell.swift
//  Shortlist
//
//  Created by Mark Wong on 3/4/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import EventKit
import UIKit

class ReminderCell: UITableViewCell {
	
	var reminder: EKReminder? {
		didSet {
			configure(with: reminder)
		}
	}
	
    lazy var taskName: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.keyboardType = UIKeyboardType.default
        view.keyboardAppearance = UIKeyboardAppearance.dark
		view.textColor = Theme.Font.DefaultColor.adjust(by: -50.0)
        view.returnKeyType = UIReturnKeyType.done
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textContainerInset = UIEdgeInsets.zero
        view.textContainer.lineFragmentPadding = 0
		view.isEditable = false
		view.isSelectable = false
		view.isUserInteractionEnabled = false
		view.isScrollEnabled = false
        return view
    }()
	
    lazy var categoryTitle: UITextView = {
        let view = UITextView()
		view.backgroundColor = UIColor.clear
        view.keyboardType = UIKeyboardType.default
        view.keyboardAppearance = UIKeyboardAppearance.dark
        view.textColor = Theme.Font.DefaultColor
		view.layer.cornerRadius = 4.0
		view.layer.backgroundColor = UIColor.black.adjust(by: 50)?.cgColor
        view.returnKeyType = UIReturnKeyType.done
        view.textContainerInset = UIEdgeInsets.zero
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textContainerInset = UIEdgeInsets.zero
        view.textContainer.lineFragmentPadding = 0
		view.isEditable = false
		view.isSelectable = false
		view.isUserInteractionEnabled = false
		view.isScrollEnabled = false
        return view
    }()

	
	lazy var fadedBackground: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutIfNeeded() {
		super.layoutIfNeeded()
		fadedBackground.anchorView(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 2.0, left: 5.0, bottom: -2.0, right: -5.0), size: .zero)

	}
	
	func setupCell() {
		backgroundColor = .clear
		contentView.addSubview(fadedBackground)
        contentView.addSubview(taskName)
		contentView.addSubview(categoryTitle)
		
		taskName.anchorView(top: contentView.topAnchor, bottom: nil, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 20.0, left: 20.0, bottom: -5.0, right: -20.0), size: .zero)
		categoryTitle.anchorView(top: taskName.bottomAnchor, bottom: contentView.bottomAnchor, leading: taskName.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 5.0, left: 0.0, bottom: -5.0, right: 0.0), size: .zero)
		categoryTitle.textContainerInset = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)

	}
	
    func configure(with reminder: EKReminder?) {
		if let reminder = reminder {
			let nameAttributedStr = NSMutableAttributedString(string: reminder.title, attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!])
			
            taskName.attributedText = nameAttributedStr

			let categoryAttributedStr = NSMutableAttributedString(string: reminder.calendar.title, attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b4).value)!])
			categoryTitle.attributedText = categoryAttributedStr
			
			priorityColor(convertApplePriorityToShortlist(applePriority: reminder.priority))
		} else {
            taskName.attributedText = NSAttributedString(string: "Unknown Task", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!])

			priorityColor(3) // 3 is no color
		}
    }
	
	func convertApplePriorityToShortlist(applePriority: Int) -> Int16 {
		switch applePriority {
			case 0: // low/none
				return Priority.low.rawValue
			case 5:
				return Priority.medium.rawValue
			case 1:
				return Priority.high.rawValue
			case 9:
				return Priority.low.rawValue
			default:
				return Priority.low.rawValue
		}
	}
	
	private func priorityColor(_ priorityLevel: Int16) {
		if let p = Priority.init(rawValue: priorityLevel) {
			switch p {
				case .high:
					fadedBackground.backgroundColor = Theme.Priority.highColor.withAlphaComponent(0.1)
				case .medium:
					fadedBackground.backgroundColor = Theme.Priority.mediumColor.withAlphaComponent(0.1)
				case .low:
					fadedBackground.backgroundColor = Theme.Priority.lowColor.withAlphaComponent(0.1)
				case .none:
					()
			}
		}
	}
	
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: .none)
    }
}
