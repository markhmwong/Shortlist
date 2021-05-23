//
//  TaskDetailTitleCell.swift
//  Shortlist
//
//  Created by Mark Wong on 29/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

// MARK: - Notes Cell
extension UICellConfigurationState {
	var notesItem: NotesItem? {
		set { self[.notesItem] = newValue }
		get { return self[.notesItem] as? NotesItem }
	}
}

fileprivate extension UIConfigurationStateCustomKey {
	static let notesItem = UIConfigurationStateCustomKey("com.whizbang.state.notes")
}

protocol TaskDetailAnimation {
    func animate()
}

//convert all these cells to collectionview cells
class TaskDetailNotesCell: BaseListCell<NotesItem>, TaskDetailAnimation {
	
	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.notesItem = self.item
		return state
	}
	
	private var viewConstraintCheck: NSLayoutConstraint? = nil

	
	private var highlight: CAShapeLayer = CAShapeLayer()

    private lazy var label: PaddedLabel = {
        let label = PaddedLabel(xPadding: 8.0, yPadding: 5.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeV2.TextColor.DefaultColor
        label.backgroundColor = ThemeV2.Background.adjust(by: 5)!
        label.alpha = 1.0
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()
	
	private func setupViewsIfNeeded() {
		guard viewConstraintCheck == nil else { return }
        backgroundColor = ThemeV2.Background
        contentView.backgroundColor = backgroundColor
        contentView.addSubview(label)

        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        viewConstraintCheck = label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        viewConstraintCheck?.isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -10).isActive = true



	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
	}
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		setupViewsIfNeeded()

		let emptyText = "Note is empty"
        
		if (state.notesItem != nil) {
			if (state.notesItem?.isButton ?? false) {
				highlight.fillColor = UIColor.clear.cgColor
                label.text = "+ Add a Note"
                label.textColor = ThemeV2.TextColor.DefaultColor
                label.layer.borderColor = label.textColor.adjust(by: 35.0)!.cgColor
                label.layer.borderWidth = 1.0
			} else {
                label.text = "\(state.notesItem?.notes ?? emptyText)"
			}
		} else {
            label.text = emptyText
		}
	}
    
    func animate() {
        self.label.alpha = 0.3
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [.curveEaseInOut]) {
            self.label.alpha = 1.0
        } completion: { (_) in
            
        }
    }
}


// MARK: - Reminder Cell
class TaskDetailReminderCell: BaseCollectionViewCell<ReminderItem> {
	
	private let reminderLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.backgroundColor = .clear
		label.font = ThemeV2.CellProperties.HeadingBoldFont
		label.textColor = ThemeV2.TextColor.DefaultColor
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupCellViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		layer.cornerRadius = rect.height / 2
		layer.borderWidth = 4.0
		layer.borderColor = ThemeV2.TextColor.DefaultColor.cgColor
	}
	
	override func setupCellViews() {
		super.setupCellViews()
		
		contentView.addSubview(reminderLabel)
		
		reminderLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0.0).isActive = true
		reminderLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0.0).isActive = true
	}
	
	override func configureCell(with item: ReminderItem) {
		reminderLabel.text = "12:30pm"//item.reminder
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		reminderLabel.text = nil
	}
}
