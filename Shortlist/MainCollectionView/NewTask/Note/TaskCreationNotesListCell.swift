//
//  TaskCreationTaskNote.swift
//  Shortlist
//
//  Created by Mark Wong on 1/12/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

private extension UICellConfigurationState {
	var taskCreationOptionsItem: TaskCreationNotesItem? {
		set { self[.item] = newValue }
		get { return self[.item] as? TaskCreationNotesItem }
	}
}

fileprivate extension UIConfigurationStateCustomKey {
	static let item = UIConfigurationStateCustomKey("com.whizbang.state.taskCreationNotes")
}

class TaskCreationNotesListCell: BaseListCell<TaskCreationNotesItem>, UITextViewDelegate {
	
//	var delegate: TaskCreationNotesViewController? = nil
	
	private var textViewHeight: CGFloat = .zero

	private lazy var textView: UITextView = {
		let view = UITextView()
		view.isEditable = true
		view.delegate = self
		view.isScrollEnabled = false
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var textLabel: UILabel = {
		let view = UILabel()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.font = ThemeV2.CellProperties.Title3Light
		return view
	}()
	
	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.taskCreationOptionsItem = self.item
		return state
	}
	
	private func defaultListContentConfiguration() -> UIListContentConfiguration {
		return .sidebarHeader()
	}
	
	private var viewConstraintCheck: NSLayoutConstraint? = nil

	private lazy var listContentView = UIListContentView(configuration: defaultListContentConfiguration())
	
	private func setupViewsIfNeeded() {
		guard viewConstraintCheck == nil else { return }
		backgroundColor = .clear
		contentView.backgroundColor = .clear
		contentView.addSubview(listContentView)
		listContentView.translatesAutoresizingMaskIntoConstraints = false
		
		listContentView.addSubview(textLabel)
		listContentView.addSubview(textView)
		
		textView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 20).isActive = true
		textView.leadingAnchor.constraint(equalTo: listContentView.leadingAnchor, constant: 5).isActive = true
		textView.trailingAnchor.constraint(equalTo: listContentView.trailingAnchor, constant: 0).isActive = true
		textView.bottomAnchor.constraint(equalTo: listContentView.bottomAnchor, constant: 0).isActive = true
		
		textLabel.topAnchor.constraint(equalTo: listContentView.topAnchor, constant: 20).isActive = true
		textLabel.leadingAnchor.constraint(equalTo: listContentView.leadingAnchor, constant: 5).isActive = true
		textLabel.trailingAnchor.constraint(equalTo: listContentView.trailingAnchor, constant: 0).isActive = true
		
		listContentView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		let bottomConstraint = listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		bottomConstraint.isActive = true
		listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
		listContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
		
		viewConstraintCheck = bottomConstraint
	}
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		setupViewsIfNeeded()
		
		if let num = state.taskCreationOptionsItem?.noteNumber {
			textLabel.text = "Note \(num)."
		} else {
			textLabel.text = "Note 0."
		}
		
		let content: UIListContentConfiguration = defaultListContentConfiguration().updated(for: state)
		textView.attributedText = NSAttributedString(string: "\(state.taskCreationOptionsItem?.description ?? "Unknown")", attributes: [NSAttributedString.Key.font: ThemeV2.CellProperties.PrimaryFont, NSAttributedString.Key.foregroundColor : ThemeV2.TextColor.DefaultColor])
		listContentView.configuration = content
	}
	
	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
	  //this assumes that collection view already correctly laid out the cell
	  //to the correct height for the contents of the UITextView
	  //textViewHeight simply needs to catch up to it before user starts typing
	  let fittingSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
	  textViewHeight = fittingSize.height

	  return true
	}

	func textViewDidChange(_ textView: UITextView) {
		//flag to determine whether textview's size is changing
		//calculate fitting size after the content has changed
		let fittingSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))

		//if the current height is not equal to
		if textViewHeight != fittingSize.height {
			//save the new height
			textViewHeight = fittingSize.height
		}

		//notify the cell's delegate (most likely a UIViewController)
		//that UITextView's intrinsic content size has changed
		//perhaps with a protocol such as this:
//		delegate?.textViewDidChange(newText: textView.text ?? "")
	}
}
