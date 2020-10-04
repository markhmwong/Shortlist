//
//  NotesCell.swift
//  Shortlist
//
//  Created by Mark Wong on 1/10/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

private extension UICellConfigurationState {
	var optionNotesItem: OptionsNotesItem? {
		set { self[.optionNotesItem] = newValue }
		get { return self[.optionNotesItem] as? OptionsNotesItem }
	}
}

fileprivate extension UIConfigurationStateCustomKey {
	static let optionNotesItem = UIConfigurationStateCustomKey("com.whizbang.state.optionsNotesItem")
}

// MARK: - Calendar Cell
class OptionsNotesCell: BaseListCell<OptionsNotesItem>, UITextViewDelegate {
	
	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.optionNotesItem = self.item
		return state
	}
	
	private func defaultListContentConfiguration() -> UIListContentConfiguration {
		return .valueCell()
	}
	
	private lazy var textView: UITextView = {
		let view = UITextView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.text = "Text View Test"
		view.delegate = self
		view.isScrollEnabled = false
//		view.sizeToFit()
		return view
	}()
	
//	private lazy var listContentView = UIListContentView(configuration: defaultListContentConfiguration())

	private var viewConstraintCheck: NSLayoutConstraint? = nil
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupViewsIfNeeded() {
//		guard viewConstraintCheck == nil else { return }
		
		contentView.addSubview(textView)
		
//		let bottomConstraint = textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//		bottomConstraint.isActive = true
//		viewConstraintCheck = bottomConstraint
		
		viewConstraintCheck = textView.topAnchor.constraint(equalTo: contentView.topAnchor)
		viewConstraintCheck?.isActive = true

		textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
		textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
		
//		contentView.addSubview(listContentView)
//
//		listContentView.translatesAutoresizingMaskIntoConstraints = false
//		listContentView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//		let bottomConstraint = listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//		bottomConstraint.isActive = true
//		listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//		listContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
		
//		viewConstraintCheck = bottomConstraint
	}
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		setupViewsIfNeeded()
		
//		let valueConfiguration = UIListContentConfiguration.cell().updated(for: state)
		textView.text = state.optionNotesItem?.note ?? "Unknown Note Item"

		
//		var config = OptionsNotesConfig() // views are palced inside a subclass of UIContentConfiguration
//		config.text = state.optionNotesItem?.note ?? "Unknown"
//		self.contentConfiguration = config
//		listContentView.configuration = config
	}
	
	func textViewDidChange(_ textView: UITextView) {
		let fixedWidth = textView.frame.size.width
		textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
		let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
		var newFrame = textView.frame
		newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
		textView.frame = newFrame
	}
}
