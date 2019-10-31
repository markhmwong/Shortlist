//
//  MainInputView.swift
//  Shortlist
//
//  Created by Mark Wong on 21/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class MainInputView: UIView {
	
	enum TextViewTag: Int {
		case TaskName = 0
		case CategoryName
	}
	
	private let taskTextFieldCharacterLimit: Int = 240
	
	weak var delegate: MainViewController?
	
	private var taskName: String? = ""
	
	private var categoryName: String? = ""
	
	private let padding: CGFloat = 10.0
	
	private let defaultText: String = "An interesting task.."
	
	private let taskNamePlaceholder: NSMutableAttributedString = NSMutableAttributedString(string: "An interesting task..", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b2).value)!])
	
	private let categoryNamePlaceholder: NSMutableAttributedString = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b2).value)!])
	
	lazy var taskTextView: UITextView = {
		let view = UITextView()
		view.delegate = self
		view.backgroundColor = Theme.Cell.textFieldBackground
		view.translatesAutoresizingMaskIntoConstraints = false
		view.isEditable = true
		view.isUserInteractionEnabled = true
		view.isSelectable = true
		view.isScrollEnabled = false
		view.returnKeyType = UIReturnKeyType.done
        view.textColor = Theme.Font.Color
        view.keyboardAppearance = UIKeyboardAppearance.dark
		view.keyboardType = UIKeyboardType.default
		view.attributedText = taskNamePlaceholder
		view.tag = 0
		return view
	}()
	
	private lazy var buttonContainer: UIView = {
		let view = UIView()
		view.backgroundColor = Theme.Cell.textFieldBackground
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var postTaskButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage(named:"Send.png"), for: .normal)
		button.addTarget(self, action: #selector(handlePostTask), for: .touchUpInside)
		return button
	}()
	
	private lazy var reminderButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage(named:"Alarm.png"), for: .normal)
		button.addTarget(self, action: #selector(handleReminder), for: .touchUpInside)
		return button
	}()
	
	lazy var categoryButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setAttributedTitle(NSMutableAttributedString(string: "Uncategorized", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b4).value)!]), for: .normal)
		button.addTarget(self, action: #selector(handleCategory), for: .touchUpInside)
		button.layer.cornerRadius = 10.0
		button.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
		button.layer.backgroundColor = UIColor.black.adjust(by: 10)?.cgColor
		return button
	}()
	
	private lazy var progressBar: ProgressBarContainer = {
		let view = ProgressBarContainer()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	init(delegate: MainViewController) {
		self.delegate = delegate
		super.init(frame: .zero)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupView() {
		addSubview(taskTextView)
		addSubview(buttonContainer)
		addSubview(postTaskButton)
		addSubview(categoryButton)
		addSubview(reminderButton)
		addSubview(progressBar)

		taskTextView.anchorView(top: topAnchor, bottom: buttonContainer.topAnchor, leading: leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: .zero)
		buttonContainer.anchorView(top: taskTextView.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 35.0)) // update height for varied screens
		postTaskButton.anchorView(top: nil, bottom: buttonContainer.bottomAnchor, leading: nil, trailing: buttonContainer.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -padding, right: -padding), size: .zero)
		reminderButton.anchorView(top: nil, bottom: buttonContainer.bottomAnchor, leading: buttonContainer.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: padding, bottom: -padding, right: 0.0), size: .zero)
		categoryButton.anchorView(top: nil, bottom: buttonContainer.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: buttonContainer.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -padding / 2.0, right: 0.0), size: .zero)
		progressBar.anchorView(top: taskTextView.topAnchor, bottom: nil, leading: taskTextView.trailingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: padding, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: 0.0, height: 0.0))
		keyoardNotification()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		sizeIconsInInputField()
	}
	
	private func keyoardNotification() {
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardDidHideNotification, object: nil)

	}
	
	func taskFirstResponder() {
		taskTextView.becomeFirstResponder()
	}
	
	func taskResignFirstResponder() {
		taskTextView.resignFirstResponder()
	}
	
	func sizeIconsInInputField() {
		let height = buttonContainer.frame.height - buttonContainer.frame.height * 0.55
		postTaskButton.heightAnchor.constraint(equalToConstant: height).isActive = true
		postTaskButton.widthAnchor.constraint(equalToConstant: height).isActive = true
		
		reminderButton.heightAnchor.constraint(equalToConstant: height).isActive = true
		reminderButton.widthAnchor.constraint(equalToConstant: height).isActive = true
		
		progressBar.heightAnchor.constraint(equalToConstant: height).isActive = true
		progressBar.widthAnchor.constraint(equalToConstant: height).isActive = true
		
		taskTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -height - padding).isActive = true
	}
	
	private func defaultTaskTextViewState() {
		taskTextView.text = defaultText
		taskTextView.textColor = UIColor.lightGray
	}

	/// Buttons
	// Saves and posts task when the arrow is selected
	//let viewmodel handle this
	@objc
	func handlePostTask() {
		guard let delegate = delegate else { return }
		taskTextView.resignFirstResponder()
		taskName = taskTextView.text
		categoryName = delegate.viewModel?.category ?? "Uncategorized"
		delegate.postTask(task: taskName ?? "An interesting task..", category: categoryName ?? "Uncategorized")
	}
	
	@objc
	func handleCategory() {
		guard let delegate = delegate else { return }
		delegate.showCategory()
		// build coordinator and show list of categories
	}
	
	@objc
	func handleKeyboardNotification(_ notification : Notification?) {
		if let info = notification?.userInfo {
			let isKeyboardHidden = notification?.name == UIResponder.keyboardDidHideNotification
			if (isKeyboardHidden) {
				defaultTaskTextViewState()
			}
		}
	}
	
	@objc
	func handleReminder() {
		guard let delegate = delegate else { return }
		delegate.showTimePicker()
	}
}

extension MainInputView: UITextViewDelegate {
	
	// We're using this to dynamically adjust task name height when typing
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
			taskTextView.sizeToFit()
            UIView.setAnimationsEnabled(true)
        }
		
		let currLimit: CGFloat = CGFloat(textView.text.count) / CGFloat(taskTextFieldCharacterLimit)
		progressBar.updateProgressBar(currLimit)
		progressBar.updateColor(currLimit)
    }
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		let currLimit = textView.text.count + (text.count - range.length)
		
		if (currLimit >= taskTextFieldCharacterLimit) {
			let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
			impactFeedbackgenerator.prepare()
			impactFeedbackgenerator.impactOccurred()
			return false
		}
		
		if (text == "\n") {
			if let nextField = textView.superview?.viewWithTag(textView.tag + 1) {
				taskName = textView.text
				nextField.becomeFirstResponder()
				return false
			} else {
				categoryName = textView.text

				// save
				guard let delegate = delegate else {
					return true
				}
				delegate.saveInput(task: taskName ?? "An interesting task..", category: categoryName ?? "uncategorized")
				textView.resignFirstResponder()
				
				return false
			}
		}
		
		if let tag = TextViewTag.init(rawValue: textView.tag) {
			// Replaces placeholder text with user entered text
			if (tag == TextViewTag.TaskName && textView.textColor == UIColor.lightGray) {
				textView.clearTextOnFirstInput(Theme.Font.Color)
			}
		}
		
		return true
	}
	
	func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		return true
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if let tag = TextViewTag.init(rawValue: textView.tag) {
			if (tag == TextViewTag.CategoryName) {
				// reset text views
				if (taskTextView.text == "An interesting task..") {
					taskTextView.attributedText = taskNamePlaceholder
				}
			}
		}
	}
}


