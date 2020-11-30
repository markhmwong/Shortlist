//
//  NewTaskStage2ViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 15/11/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class TaskCreationCategoryViewController: UIViewController, UITextFieldDelegate, CategoryInputViewProtocol {
	func addCategory() {
		//
	}
	
	
	private var viewModel: TaskCreationViewModel
	
	private var coordinator: NewTaskCoordinator
	
	private lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.alpha = 1.0
		label.font = ThemeV2.CellProperties.Title3Bold
		label.text = "Category"
		return label
	}()
	
	private lazy var nameDescriptionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.alpha = 0.7
		label.numberOfLines = 0
		label.font = ThemeV2.CellProperties.TertiaryFont
		label.text = "Categorise your task. Typing a new category will automatically be added to the category list."
		return label
	}()
	
	private lazy var bottomNavBar: KeyboardNavigationContainer = {
		let view = KeyboardNavigationContainer()
		view.alpha = 0.0
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var categoryInput: SelectCategoryInputView = {
		let view = SelectCategoryInputView(type: .category, delegate: self, persistentContainer: viewModel.persistentContainer)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	// used for keyboard
	internal var bottomConstraint: NSLayoutConstraint? = nil
	
	init(viewModel: TaskCreationViewModel, coordinator: NewTaskCoordinator) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let topPadding: CGFloat = 30.0
		let leftPadding: CGFloat = 20.0
		let interimSpacing: CGFloat = leftPadding

		view.backgroundColor = ThemeV2.Background
		view.addSubview(bottomNavBar)
		
//		nextButtonContainer.nextClosure = {
//			self.handleNextButton()
//		}
		
		bottomNavBar.doneClosure = {
			self.handleDoneButton()
		}
		
		view.addSubview(nameLabel)
		view.addSubview(nameDescriptionLabel)
		view.addSubview(bottomNavBar)
		view.addSubview(categoryInput)
		
		nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPadding).isActive = true
		nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftPadding).isActive = true
		
		nameDescriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: topPadding / 4).isActive = true
		nameDescriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
		nameDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

		categoryInput.topAnchor.constraint(equalTo: nameDescriptionLabel.bottomAnchor, constant: interimSpacing).isActive = true
		categoryInput.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
		categoryInput.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
		
		bottomNavBar.anchorView(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 50.0))
		bottomConstraint = NSLayoutConstraint(item: bottomNavBar, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		view.addConstraint(bottomConstraint!)
		keyboardNotifications()
	}
	
	// MARK: - Keyboard Observers
	func keyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	// MARK: - Navigation
	func handleNextButton() {
		
	}
	
	func handleDoneButton() {
		
	}
	
	// MARK: - Keyboard Notification
	@objc func handleKeyboardNotification(_ notification : Notification?) {
		if let info = notification?.userInfo {
			let isKeyboardShowing = notification?.name == UIResponder.keyboardWillShowNotification
			let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
			if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
				viewModel.keyboardSize = kbFrame
				
				if (isKeyboardShowing) {
					bottomNavBar.alpha = 1.0
					bottomConstraint?.constant = -kbFrame.height
				} else {
					bottomNavBar.alpha = 0.0
					bottomConstraint?.constant = 0
				}
			}
		}
	}
}
