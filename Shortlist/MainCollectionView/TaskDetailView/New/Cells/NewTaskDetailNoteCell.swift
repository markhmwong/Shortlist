//
//  NewTaskDetailNoteCell.swift
//  Shortlist
//
//  Created by Mark Wong on 10/2/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit

extension UICellConfigurationState {
	var newTaskDetailNoteItem: NewTaskDetailNoteItem? {
		set { self[.newTaskDetailNoteItem] = newValue }
		get { return self[.newTaskDetailNoteItem] as? NewTaskDetailNoteItem }
	}
}

fileprivate extension UIConfigurationStateCustomKey {
	static let newTaskDetailNoteItem = UIConfigurationStateCustomKey("com.whizbang.cell.newTask.note")
}

class NewTaskDetailNoteCell: BaseCell<NewTaskDetailNoteItem> {
	
	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.newTaskDetailNoteItem = self.item
		return state
	}
	
	private lazy var redact: UIImageView = {
		let config = UIImage.SymbolConfiguration(pointSize: UIFont.systemFontSize)
		let image = UIImage(systemName: "eye.slash", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
		let view = UIImageView(image: image)
		view.tintColor = UIColor.systemPink.darker(by: 60)!
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var taskName: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "High"
		label.numberOfLines = 0
		label.font = UIFont.preferredFont(forTextStyle: .title2).with(weight: .regular)
		label.textColor = UIColor.offBlack
		return label
	}()
	
	private var viewConstraintCheck: NSLayoutConstraint? = nil
	
	private func setupViewsIfNeeded() {
		guard viewConstraintCheck == nil else { return }
		let bg = UIView()
		bg.backgroundColor = UIColor.offWhite
		backgroundView = bg
		
		contentView.addSubview(taskName)
		
		viewConstraintCheck = taskName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
		viewConstraintCheck?.isActive = true
		taskName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25).isActive = true
		taskName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25).isActive = true
		taskName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
	}
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		setupViewsIfNeeded()
		taskName.text = state.newTaskDetailNoteItem?.name
	}
}
