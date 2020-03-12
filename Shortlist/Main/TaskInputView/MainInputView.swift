//
//  MainInputView.swift
//  Shortlist
//
//  Created by Mark Wong on 21/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

enum TaskInputState {
	case writing
	case closed
}

class MainInputView: UIView {
	
	enum TextViewTag: Int {
		case TaskName = 0
		case CategoryName
	}
	
	private var state: TaskInputState = .closed
	
	weak var delegate: MainViewControllerProtocol?
	
	private var priority: Int = Int(Priority.high.rawValue)
	
	private var categoryName: String? = ""
	
	private let padding: CGFloat = 10.0
	
	private let defaultText: String = "An interesting task.."
	
	private let taskNamePlaceholder: NSMutableAttributedString = NSMutableAttributedString(string: "An interesting task..", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor.adjust(by: -30.0)!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b2).value)!])
	
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
		view.returnKeyType = UIReturnKeyType.default
        view.textColor = Theme.Font.DefaultColor
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
		button.setAttributedTitle(NSMutableAttributedString(string: "Uncategorized", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor.adjust(by: -70)!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b4).value)!]), for: .normal)
		button.addTarget(self, action: #selector(handleCategory), for: .touchUpInside)
		button.layer.cornerRadius = 10.0
		button.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
		button.layer.backgroundColor = UIColor.black.adjust(by: 80)?.cgColor
		return button
	}()
	
	private lazy var priorityButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setAttributedTitle(NSMutableAttributedString(string: "M", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b4).value)!]), for: .normal)
		button.addTarget(self, action: #selector(handlePriority), for: .touchUpInside)
		button.layer.cornerRadius = 10.0
		button.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
		button.layer.backgroundColor = Theme.Priority.mediumColor.cgColor
		return button
	}()
	
	private lazy var progressBar: ProgressBarContainer = {
		let view = ProgressBarContainer()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	init(delegate: MainViewControllerProtocol) {
		self.delegate = delegate
		super.init(frame: .zero)
		state = .closed
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
		addSubview(priorityButton)
		
		taskTextView.anchorView(top: topAnchor, bottom: buttonContainer.topAnchor, leading: leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: .zero)
		buttonContainer.anchorView(top: taskTextView.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 35.0)) // update height for varied screens
		postTaskButton.anchorView(top: nil, bottom: buttonContainer.bottomAnchor, leading: nil, trailing: buttonContainer.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -padding, right: -padding), size: .zero)
		reminderButton.anchorView(top: nil, bottom: buttonContainer.bottomAnchor, leading: buttonContainer.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: padding, bottom: -padding, right: 0.0), size: .zero)
		categoryButton.anchorView(top: nil, bottom: buttonContainer.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: buttonContainer.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -padding / 2.0, right: 0.0), size: .zero)
		progressBar.anchorView(top: taskTextView.topAnchor, bottom: nil, leading: taskTextView.trailingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: padding, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: 0.0, height: 0.0))
		priorityButton.anchorView(top: nil, bottom: buttonContainer.bottomAnchor, leading: reminderButton.trailingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: padding, bottom: -padding / 2.0, right: 0.0), size: .zero)
		keyoardNotification()
		initialisePriorityButton()
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
		let height = buttonContainer.frame.height - buttonContainer.frame.height * 0.45
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
	
	// replaces the user entered input with the placeholder
	func resetTextView() {
		guard let delegate = delegate else { return }
		guard let vm = delegate.viewModel else { return }

		if (taskTextView.text != defaultText) {
			taskTextView.attributedText = taskNamePlaceholder
			vm.taskName = defaultText
			vm.priority = .high
			vm.category = "Uncategorized"
			priority = Int(Priority(rawValue: 0)?.rawValue ?? 0)
			
			updatePriorityButton(string: "H", color: Theme.Priority.highColor)
			categoryButton.setAttributedTitle(NSMutableAttributedString(string: "\(vm.category ?? "Uncategorized")", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b4).value)!]), for: .normal)
		}
	}

	/// Buttons
	// Saves and posts task when the arrow is selected
	// let viewmodel handle user input data.
	@objc
	func handlePostTask() {
		state = .closed
		guard let delegate = delegate else { return }
		guard let vm = delegate.viewModel else { return }
		taskTextView.resignFirstResponder()
		vm.taskName = taskTextView.text
		vm.priority = Priority(rawValue: Int16(priority)) ?? .high
		categoryName = delegate.viewModel?.category ?? "Uncategorized"
		delegate.postTask(taskName: vm.taskName, category: categoryName ?? "Uncategorized", priorityLevel: Int(vm.priority.rawValue))
		resetTextView()
	}
	
	@objc
	func handleCategory() {
		guard let delegate = delegate else { return }
		delegate.showCategory()
		// build coordinator and show list of categories
	}
	
	@objc
	func handleKeyboardNotification(_ notification : Notification?) {
		let isKeyboardHidden = notification?.name == UIResponder.keyboardDidHideNotification
		if (isKeyboardHidden && taskTextView.text == defaultText) {
			defaultTaskTextViewState()
		}
	}
	
	@objc
	func handleReminder() {
		guard let delegate = delegate else { return }
		delegate.showTimePicker()
	}
	
	// cycles between three priority levels
	@objc
	func handlePriority() {
		
		if (priority != Int(Priority.low.rawValue)) {
			priority = priority + 1
		} else {
			//reset
			priority = Int(Priority.high.rawValue)
		}
		
		if let p = Priority(rawValue: Int16(priority)) {
			switch p {
				case .high:
					updatePriorityButton(string: "H", color: Theme.Priority.highColor)
				case .medium:
					updatePriorityButton(string: "M", color: Theme.Priority.mediumColor)
				case .low:
					updatePriorityButton(string: "L", color: Theme.Priority.lowColor)
				case .none:
					updatePriorityButton(string: "N", color: Theme.Priority.noneColor)
			}
		}
	}
	
	func initialisePriorityButton() {
		if let p = Priority(rawValue: Int16(priority)) {
			switch p {
				case .high:
					updatePriorityButton(string: "H", color: Theme.Priority.highColor)
				case .medium:
					updatePriorityButton(string: "M", color: Theme.Priority.mediumColor)
				case .low:
					updatePriorityButton(string: "L", color: Theme.Priority.lowColor)
				case .none:
					updatePriorityButton(string: "N", color: Theme.Priority.noneColor)
			}
		}
	}
	
	func updatePriorityButton(string: String, color: UIColor) {
		DispatchQueue.main.async {
			self.priorityButton.layer.backgroundColor = color.cgColor
			self.priorityButton.setAttributedTitle(NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b4).value)!]), for: .normal)
		}
	}
	
	deinit {
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
		
		let currLimit: CGFloat = CGFloat(textView.text.count) / CGFloat(TaskCharacterLimits.taskNameMaximumCharacterLimit)
		progressBar.updateProgressBar(currLimit)
		progressBar.updateColor(currLimit)
    }
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		let currLimit = textView.text.count + (text.count - range.length)
		
		// produces physical haptic feedback for the user once the character limit is reached
		if (currLimit >= TaskCharacterLimits.taskNameMaximumCharacterLimit) {
			ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
			return false
		}
		
		// Replaces placeholder text with user entered text
		if let tag = TextViewTag.init(rawValue: textView.tag) {
			if (tag == TextViewTag.TaskName && state == .closed) {
				state = .writing
				textView.clearTextOnFirstInput(Theme.Font.DefaultColor)
			}
		}
		
		return true
	}
	
	func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		return true
	}
	
	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		
		guard let vm = delegate?.viewModel else { return false }
		textView.text = vm.taskName
		return true
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		state = .closed
		guard let vm = delegate?.viewModel else { return }
		vm.taskName = textView.text
		
		if let tag = TextViewTag.init(rawValue: textView.tag) {
			if (tag == TextViewTag.CategoryName) {
				resetTextView()
			}
		}
	}
}


