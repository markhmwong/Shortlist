//
//  TaskCreationOptionsBar.swift
//  Shortlist
//
//  Created by Mark Wong on 24/11/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class TaskCreationOptionsBar: UIView {
	
	// stackview of options
	
	private lazy var reminder: UIButton = {
		let config = UIImage.SymbolConfiguration(font: ThemeV2.CellProperties.PrimaryFont, scale: .default)
		let image = UIImage.init(systemName: Icons.reminder.sfSymbolString, withConfiguration: config)
		
		let view = UIImageView(image: image)
		view.contentMode = .center
		let button = UIButton()
		button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
		button.setImage(image, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(handleReminderButton), for: .touchDown)
		return button
	}()
	
	private lazy var notes: UIButton = {
		let config = UIImage.SymbolConfiguration(font: ThemeV2.CellProperties.PrimaryFont, scale: .default)
		let image = UIImage.init(systemName: Icons.notes.sfSymbolString, withConfiguration: config)
		let view = UIImageView(image: image)
		view.contentMode = .center
		let button = UIButton()
		button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
		button.setImage(image, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(handleNotesButton), for: .touchDown)
		return button
	}()
	
	private lazy var photo: UIButton = {
		let config = UIImage.SymbolConfiguration(font: ThemeV2.CellProperties.PrimaryFont, scale: .default)
		let image = UIImage.init(systemName: Icons.photo.sfSymbolString, withConfiguration: config)
		let view = UIImageView(image: image)
		view.contentMode = .center
		let button = UIButton()
		button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
		button.setImage(image, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(handlePhotoButton), for: .touchDown)
		return button
	}()
	
	private lazy var redact: UIButton = {
		let config = UIImage.SymbolConfiguration(font: ThemeV2.CellProperties.PrimaryFont, scale: .default)
		let image = UIImage.init(systemName: Icons.redact.sfSymbolString, withConfiguration: config)
		let view = UIImageView(image: image)
		view.contentMode = .center
		let button = UIButton()
		button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
		button.setImage(image, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(handleRedactButton), for: .touchDown)
		return button
	}()
	
	private lazy var category: UIButton = {
		let config = UIImage.SymbolConfiguration(font: ThemeV2.CellProperties.PrimaryFont, scale: .default)
		let image = UIImage.init(systemName: Icons.category.sfSymbolString, withConfiguration: config)
		let view = UIImageView(image: image)
		view.contentMode = .center
		let button = UIButton()
		button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
		button.setImage(image, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(handleCategoryButton), for: .touchDown)
		return button
	}()
	
	private lazy var stackView: UIStackView = {
		let view = UIStackView(arrangedSubviews: [reminder, notes, photo, redact, category])
		view.translatesAutoresizingMaskIntoConstraints = false
//		view.alignment = .fill
		view.axis = .horizontal
		view.distribution = .fillEqually
		return view
	}()
	
	// public closures
	var categoryButton: (() -> ())? = nil
	
	var photoButton: (() -> ())? = nil
	
	var redactButton: (() -> ())? = nil
	
	var reminderButton: (() -> ())? = nil
	
	var notesButton: (() -> ())? = nil
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupView() {
		addSubview(stackView)
		
		stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}
	
	@objc func handleNotesButton() {
		notesButton?()
	}
	
	@objc func handleReminderButton() {
		reminderButton?()
	}
	
	@objc func handleRedactButton() {
		redactButton?()
	}
	
	@objc func handlePhotoButton() {
		photoButton?()
	}
	
	@objc func handleCategoryButton() {
		categoryButton?()
	}
}
