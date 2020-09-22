//
//  ContentViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 23/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

// MARK: - Content View Controller
// Edit written content
class ContentViewController: UIViewController, UITextViewDelegate {
	
	private var maxLimit = 0
	
	private var editType: TaskOptionsSection.ContentSection
	
	private var data: Task {
		didSet {
			self.dataView.text = "\(data)"
		}
	}
	
	private lazy var characterLimit: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "0/\(maxLimit)"
		label.textColor = ThemeV2.TextColor.DefaultColor
		label.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .regular)
		return label
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "AN IMPORTANT TASK"
		label.textColor = ThemeV2.TextColor.DefaultColor
		label.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .bold)
		return label
	}()
	
	private lazy var dataView: UITextView = {
		let textField = UITextView(frame: .zero)
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.text = "Unknown Data"
		textField.font = UIFont.preferredFont(forTextStyle: .title1).with(weight: .regular)
		textField.textColor = ThemeV2.TextColor.DefaultColor
		textField.autocapitalizationType = .sentences
		textField.backgroundColor = .clear
		textField.delegate = self
		return textField
	}()
	
	init(editType: TaskOptionsSection.ContentSection, data: Task) {
		self.editType = editType
		self.data = data
		super.init(nibName: nil, bundle: nil)
		// update title label
		switch editType {
			case .name:
				titleLabel.text = "A QUALITY TITLE"
				dataView.text = data.name
				maxLimit = CharacterLimitConstants.titleLimit
				updateCharacterLimit()
			case .notes:
				titleLabel.text = "QUICK NOTES"
				dataView.text = data.details
				maxLimit = CharacterLimitConstants.noteLimit
				updateCharacterLimit()
			case .photo:
				() // do nothing
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		

	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// keyboard
		
		// navigation
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
		
		view.addSubview(dataView)
		view.backgroundColor = ThemeV2.Background
		view.addSubview(titleLabel)
		view.addSubview(characterLimit)

		titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10.0).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		
		dataView.contentInset = .zero
		dataView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0).isActive = true
		dataView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		dataView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
		dataView.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		
		characterLimit.topAnchor.constraint(equalTo: dataView.bottomAnchor).isActive = true
		characterLimit.trailingAnchor.constraint(equalTo: dataView.trailingAnchor).isActive = true
		
		dataView.becomeFirstResponder()
	}
	
	@objc func handleSave() {
		// save based on edit Type
		switch editType {
			case .name:
				()
			case .notes:
				()
			case .photo:
				() // do nothing
		}
	}
	
	private func updateCharacterLimit() {
		let currCount: Int = dataView.text.count
		characterLimit.text = "\(currCount)/\(maxLimit)"
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
				
		switch editType {
			case .name:
				maxLimit = CharacterLimitConstants.titleLimit
			default:
				maxLimit = CharacterLimitConstants.noteLimit
		}
		
		let currCount = textView.text.count + (text.count - range.length)
		if currCount <= maxLimit {
			characterLimit.text = "\(currCount)/\(maxLimit)"
			return true
		} else {
			return false
		}
	}
	
}

// MARK: - Constants
struct CharacterLimitConstants {
	static var titleLimit: Int = 100
	static var noteLimit: Int = 250
}



