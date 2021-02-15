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
import PhotosUI

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
	
	private func setupView() {
		backgroundColor = .systemGreen

		addSubview(completeButton)

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
class TaskCreationNameAndPriorityViewController: UIViewController, UITextFieldDelegate, CategoryInputViewProtocol, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	func addCategory() {
		// to do
	}
	
	private var viewModel: TaskCreationViewModel
	
	private lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.alpha = 1.0
		label.font = ThemeV2.CellProperties.Title3Bold
		label.text = "Task Name"
		return label
	}()

	
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
		view.addSubview(nameInput)
		view.addSubview(priorityButton)
		
		nameInput.becomeFirstResponder()
		
		taskOptionBar.categoryButton = {
//			self.coordinator.showCategory(viewModel: self.viewModel)
		}
		
		taskOptionBar.notesButton = {
//			self.coordinator.showNotes(viewModel: self.viewModel)
		}
		
		taskOptionBar.photoButton = {
			let ac = UIAlertController(title: "Photo Type", message: "Please choose between", preferredStyle: .actionSheet)
			let albumAction = UIAlertAction(title: "Album", style: .default) { (action) in
				// show album
				self.presentPicker(filter: PHPickerFilter.images)
			}
			
			let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
				// show camera
				self.presentCamera()
			}
			
			let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
				// show camera
			}
			ac.addAction(cancelAction)
			ac.addAction(albumAction)
			ac.addAction(cameraAction)
			self.present(ac, animated: true) {}
//			self.coordinator.showPhoto(viewModel: self.viewModel)
		}
		
		taskOptionBar.redactButton = {
//			self.coordinator.showRedact(viewModel: self.viewModel)
		}
		
		taskOptionBar.reminderButton = {
//			self.coordinator.showReminder(viewModel: self.viewModel)
		}
		
		nameInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height * 0.20).isActive = true
		nameInput.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
		nameInput.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
		
		priorityButton.topAnchor.constraint(equalTo: nameInput.bottomAnchor, constant: interimSpacing).isActive = true
		priorityButton.centerXAnchor.constraint(equalTo: nameInput.centerXAnchor).isActive = true
		
		taskOptionBar.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: topPadding, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: 0.0, height: 50.0))
		
		nameInput.becomeFirstResponder()
		
		keyboardNotifications()
	}
	
	// MARK: - Camera Options
	private func presentPicker(filter: PHPickerFilter) {
		var configuration = PHPickerConfiguration()
		configuration.filter = filter
		configuration.selectionLimit = 0
		let picker = PHPickerViewController(configuration: configuration)
		picker.delegate = self
		present(picker, animated: true)
	}
	
	private func presentCamera() {
		let vc = UIImagePickerController()
		vc.sourceType = .camera
		vc.allowsEditing = true
		vc.delegate = self
		self.present(vc, animated: true)
	}
	
	@objc func handleTap() {
		self.dismiss(animated: true, completion: nil)
	}
	
	@objc func handleDoneButton() {
		// to coordinator
//		coordinator.dismiss()
	}
	
	// MARK: - Text Field Delegate
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
				}
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
	
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		let result = results[0]
		let provider = result.itemProvider
		let state = provider.canLoadObject(ofClass: UIImage.self)
		
		if state {
			provider.loadObject(ofClass: UIImage.self) { (image, error) in
				if let i = image as? UIImage {
					self.viewModel.saveImage(imageData: i)
				}
			}
		}
	}
}
