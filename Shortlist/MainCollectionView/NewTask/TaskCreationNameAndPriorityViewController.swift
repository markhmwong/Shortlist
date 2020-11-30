//
//  NewTaskViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 12/11/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//
//	Description
//	The new task creation guide should enable the user to create a task very quickly or very carefully
//	Each stage is optional and should be quick to discard
//	Stage 1 - Name, priority, lock
// 	Stage 2 - Category
//	Stage 3 - Alarm
//	Stage 4 - Notes
//	Stage 5 - Photo
//

import UIKit

class KeyboardNavigationContainer: UIView {
	
	// public methods to link the buttons
	var doneClosure: (() -> ())?
	
//	var nextClosure: (() -> ())?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private lazy var completeButton: UIButton = {
		let button = UIButton()
		button.setAttributedTitle(NSAttributedString(string: "Done", attributes: [NSAttributedString.Key.font: ThemeV2.CellProperties.Title3Bold]), for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(handleDoneButton), for: .touchDown)
		return button
	}()
	
//	private lazy var nextButton: UIButton = {
//		let button = UIButton()
//		button.setAttributedTitle(NSAttributedString(string: "Next", attributes: [NSAttributedString.Key.font: ThemeV2.CellProperties.Title3Bold]), for: .normal)
//		button.translatesAutoresizingMaskIntoConstraints = false
//		button.addTarget(self, action: #selector(handleNextButton), for: .touchDown)
//		return button
//	}()
	
	private func setupView() {
		backgroundColor = .systemGreen

		addSubview(completeButton)
//		addSubview(nextButton)
		
//		nextButton.leadingAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//		nextButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//		nextButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//		nextButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

		completeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
		completeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
		completeButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		completeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
	}
	
	@objc func handleDoneButton() {
		doneClosure?()
	}
	
//	@objc func handleNextButton() {
//		nextClosure?()
//	}
}



/*

	MARK: - ViewController Stage 1 - Title and priority

*/
class TaskCreationNameAndPriorityViewController: UIViewController, UITextFieldDelegate, CategoryInputViewProtocol {
	
	func addCategory() {
		// to do
	}
	
	private var viewModel: TaskCreationViewModel
	
//	private lazy var imageView: UIImageView = {
//		let config = UIImage.SymbolConfiguration(pointSize: ThemeV2.CellProperties.LargeBoldFont.pointSize, weight: .bold, scale: .large)
//		let image = UIImage(systemName: "doc.append.fill", withConfiguration: config)
//		let view = UIImageView(image: image)
//		view.sizeToFit()
//		view.translatesAutoresizingMaskIntoConstraints = false
//		return view
//	}()
	
	private lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.alpha = 1.0
		label.font = ThemeV2.CellProperties.Title3Bold
		label.text = "Task Name"
		return label
	}()
	
//	private lazy var nameInput: PaddedTextField = {
//		let label = PaddedTextField()
//		label.backgroundColor = .clear
//		label.translatesAutoresizingMaskIntoConstraints = false
//		label.font = ThemeV2.CellProperties.Title3Font
//		label.textColor = ThemeV2.TextColor.DefaultColor
//		label.text = ""
//		label.placeholder = "An interesting title.. "
//		label.delegate = self
//		label.becomeFirstResponder()
//		return label
//	}()
	
	private lazy var nameInput: SelectCategoryInputView = {
		let view = SelectCategoryInputView(type: .name, delegate: self, persistentContainer: viewModel.persistentContainer)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var nameDescription: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = ThemeV2.CellProperties.TertiaryFont
		label.alpha = 0.7
		label.text = "Keep it short and sweet."
		return label
	}()
	
	private lazy var priorityDescription: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = ThemeV2.CellProperties.TertiaryFont
		label.alpha = 0.7
		label.text = "Choose from 3 levels of priority - High, Medium, Low"
		return label
	}()
	
	private lazy var priorityLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.alpha = 1.0
		label.font = ThemeV2.CellProperties.Title3Bold
		label.text = "Priority"
		return label
	}()
	
	// lock button
	
	private lazy var taskOptionBar: TaskCreationOptionsBar = {
		let view = TaskCreationOptionsBar()
		view.alpha = 1.0
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var priorityButton: UIButton = {
		let priorityButton = UIButton()
		priorityButton.translatesAutoresizingMaskIntoConstraints = false
		priorityButton.setAttributedTitle(NSAttributedString(string: Priority.high.stringValue, attributes: [NSAttributedString.Key.font : ThemeV2.CellProperties.Title3Bold]), for: .normal)
		priorityButton.tag = Int(Priority.high.rawValue)
		priorityButton.setTitleColor(Priority.high.color, for: .normal)
		priorityButton.tintColor = .systemBlue
		priorityButton.addTarget(self, action: #selector(handleButtonPriority), for: .touchDown)
		return priorityButton
	}()
	
	// used for keyboard
	internal var bottomConstraint: NSLayoutConstraint? = nil

	private var priorityButtonCollection: [UIButton] = []
	
	private var coordinator: NewTaskCoordinator
	
	init(viewModel: TaskCreationViewModel, coordinator: NewTaskCoordinator) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if (!nameInput.isFirstResponder) {
			nameInput.becomeFirstResponder()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let topPadding: CGFloat = 10.0
		let leftPadding: CGFloat = view.frame.height * 0.06
		let interimSpacing: CGFloat = leftPadding
		
		view.backgroundColor = ThemeV2.Background
		view.addSubview(taskOptionBar)
//		view.addSubview(nameLabel)
//		view.addSubview(imageView)
		view.addSubview(nameInput)
//		view.addSubview(priorityLabel)
//		view.addSubview(nameDescription)
//		view.addSubview(priorityDescription)
		view.addSubview(priorityButton)
		
		nameInput.becomeFirstResponder()
		
		taskOptionBar.categoryButton = {
			self.coordinator.showCategory(viewModel: self.viewModel)
		}
		
		taskOptionBar.notesButton = {
			self.coordinator.showNotes(viewModel: self.viewModel)
		}
		
		taskOptionBar.photoButton = {
			self.coordinator.showPhoto(viewModel: self.viewModel)
		}
		
		taskOptionBar.redactButton = {
//			toggle button instead
//			self.coordinator.showRedact()
		}
		
		taskOptionBar.reminderButton = {
			self.coordinator.showReminder(viewModel: self.viewModel)
		}
		
//		nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPadding).isActive = true
//		nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftPadding).isActive = true
		
//		nameDescription.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: topPadding / 4).isActive = true
//		nameDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftPadding).isActive = true
		
//		imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPadding).isActive = true
//		imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftPadding).isActive = true
		
		nameInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height * 0.20).isActive = true
		nameInput.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
		nameInput.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
		
//		priorityLabel.topAnchor.constraint(equalTo: nameInput.bottomAnchor, constant: topPadding).isActive = true
//		priorityLabel.leadingAnchor.constraint(equalTo: nameInput.leadingAnchor).isActive = true
//
//		priorityDescription.topAnchor.constraint(equalTo: priorityLabel.bottomAnchor, constant: topPadding / 4).isActive = true
//		priorityDescription.leadingAnchor.constraint(equalTo: nameInput.leadingAnchor).isActive = true
		
		priorityButton.topAnchor.constraint(equalTo: nameInput.bottomAnchor, constant: interimSpacing).isActive = true
		priorityButton.centerXAnchor.constraint(equalTo: nameInput.centerXAnchor).isActive = true
		
		taskOptionBar.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: topPadding, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: 0.0, height: 50.0))

//		bottomConstraint = NSLayoutConstraint(item: nextButtonContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
//		view.addConstraint(bottomConstraint!)
		
		nameInput.becomeFirstResponder()
		
		keyboardNotifications()
	}
	
	@objc func handleNextButton() {
		// to coordinator
//		coordinator.showStage2(viewModel: viewModel)
	}
	
	@objc func handleDoneButton() {
		// to coordinator
		coordinator.dismiss()
	}
	
	// MARK: - Text Field Delegate
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//		coordinator.showStage2(viewModel: viewModel)
		return true
	}
	
	// MARK: - Keyboard Observers
	func keyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	// MARK: - Keyboard Notification
	@objc func handleKeyboardNotification(_ notification : Notification?) {
		if let info = notification?.userInfo {
			let isKeyboardShowing = notification?.name == UIResponder.keyboardWillShowNotification
			let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
			if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
				viewModel.keyboardSize = kbFrame
				
				if (isKeyboardShowing) {
					taskOptionBar.alpha = 1.0
//					bottomConstraint?.constant = -kbFrame.height
				} else {
//					taskOptionBar.alpha = 0.5
//					bottomConstraint?.constant = 0
				}
//				taskOptionBar.isUserInteractionEnabled = isKeyboardShowing

			}
		}
	}
	
	@objc func handleButtonPriority(_ sender: UIButton) {
		if let priority = Priority.init(rawValue: Int16(sender.tag)) {
			switch priority {
				case .high:
					// set to medium
					sender.tag = Int(Priority.medium.rawValue)
					sender.setAttributedTitle(NSAttributedString(string: Priority.medium.stringValue, attributes: [NSAttributedString.Key.font : ThemeV2.CellProperties.Title3Regular]), for: .normal)
					sender.setTitleColor(Priority.medium.color, for: .normal)
					viewModel.assignPriority(priority: Priority.medium.rawValue)
				case .medium:
					sender.tag = Int(Priority.low.rawValue)
					sender.setAttributedTitle(NSAttributedString(string: Priority.low.stringValue, attributes: [NSAttributedString.Key.font : ThemeV2.CellProperties.Title3Light]), for: .normal)

					sender.setTitleColor(Priority.low.color, for: .normal)
					viewModel.assignPriority(priority: Priority.low.rawValue)
				case .low:
					sender.tag = Int(Priority.high.rawValue)
					sender.setAttributedTitle(NSAttributedString(string: Priority.high.stringValue, attributes: [NSAttributedString.Key.font : ThemeV2.CellProperties.Title3Bold]), for: .normal)
					sender.setTitleColor(Priority.high.color, for: .normal)
					viewModel.assignPriority(priority: Priority.high.rawValue)
				case .none:
					sender.tag = Int(Priority.high.rawValue)
					sender.setAttributedTitle(NSAttributedString(string: Priority.high.stringValue, attributes: [NSAttributedString.Key.font : ThemeV2.CellProperties.Title3Bold]), for: .normal)
					sender.setTitleColor(Priority.high.color, for: .normal)
					viewModel.assignPriority(priority: Priority.high.rawValue)
			}
		}
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		viewModel.assignTitle(taskName: textField.text ?? "None")
		return true
	}
}
