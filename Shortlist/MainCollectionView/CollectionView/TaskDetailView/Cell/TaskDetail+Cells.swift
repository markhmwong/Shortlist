//
//  TaskDetailTitleCell.swift
//  Shortlist
//
//  Created by Mark Wong on 29/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

// MARK: - Title Cell
class TaskDetailTitleCell: BaseCollectionViewCell<TitleItem> {
	
	private lazy var staticTitleLabel: BaseStaticLabel = BaseStaticLabel(frame: .zero, fontSize: 13)

	// private variables
	private lazy var editButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("Edit", for: .normal)
		button.setTitleColor(.blue, for: .normal)
		button.addTarget(self, action: #selector(handleEditButton), for: .touchDown)
		return button
	}()
	
	private lazy var bodyLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.init(name: "HelveticaNeue-Bold", size: 18)
		label.textColor = UIColor.black.lighter(by: 20.0)!
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		return label
	}()
	
	// public variables
	var editClosure: (() -> ())? = nil
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupViewAdditionalViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupViewAdditionalViews() {
		// layout cell details
		let padding: CGFloat = 15.0
		self.staticTitleLabel.text = "Task At Hand"
		
		contentView.addSubview(staticTitleLabel)
		staticTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0).isActive = true
		staticTitleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 0.0).isActive = true
		staticTitleLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: 0.0).isActive = true
		
		contentView.addSubview(bodyLabel)
		bodyLabel.topAnchor.constraint(equalTo: staticTitleLabel.bottomAnchor, constant: 10.0).isActive = true
		bodyLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
		bodyLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -padding).isActive = true
		bodyLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: 0.0).isActive = true
	}
	
	override func configureCell(with item: TitleItem) {
		bodyLabel.text = item.title
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		bodyLabel.text = nil
	}
	
	@objc func handleEditButton() {
		editClosure?()
	}
	
	// mark as complete, photo button, redact task (eye open/close), change priority, how to edit??
	// reminder
}

// MARK: - Notes Cell
class TaskDetailNotesCell: BaseCollectionViewCell<NotesItem> {
	
	private lazy var staticTitleLabel: BaseStaticLabel = BaseStaticLabel(frame: .zero, fontSize: 13)
	
	private lazy var bodyLabel: UITextView = {
		let label = UITextView(frame: .zero)
		label.font = UIFont.init(name: "HelveticaNeue", size: 13)
		label.textColor = UIColor.black.lighter(by: 40.0)!
		label.translatesAutoresizingMaskIntoConstraints = false
		label.isEditable = false
		label.backgroundColor = .clear
		label.layoutMargins = .zero
		label.textContainerInset = .zero
		label.textContainer.lineFragmentPadding = 0
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupViewAdditionalViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupViewAdditionalViews() {
		staticTitleLabel.text = "Brain Storm Notes"
		
		let padding: CGFloat = 15.0
		
		contentView.addSubview(staticTitleLabel)
		staticTitleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
		staticTitleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 0.0).isActive = true
		
		contentView.addSubview(bodyLabel)
		bodyLabel.topAnchor.constraint(equalTo: staticTitleLabel.bottomAnchor, constant: padding).isActive = true
		bodyLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
		bodyLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -padding).isActive = true
		bodyLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -5.0).isActive = true
	}
	
	override func configureCell(with item: NotesItem) {
		bodyLabel.text = item.notes
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		bodyLabel.text = nil
	}
	
	@objc func handleEditButton() {
		print("test notes")
	}
}

// MARK: - Photo Cell
class TaskDetailPhotoCell: BaseCollectionViewCell<PhotoItem> {
	
	let notesLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.backgroundColor = .clear
		label.numberOfLines = 0
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupCellViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func setupCellViews() {
		super.setupCellViews()
		contentView.addSubview(notesLabel)

		notesLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		notesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
		notesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		notesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
	}
	
	override func configureCell(with item: PhotoItem) {
		notesLabel.text = item.photo
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		notesLabel.text = nil
	}
}

// MARK: - Reminder Cell
class TaskDetailReminderCell: BaseCollectionViewCell<ReminderItem> {
	
	let notesLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.backgroundColor = .clear
		label.numberOfLines = 0
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupCellViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func setupCellViews() {
		super.setupCellViews()
		backgroundColor = .orange
		
		contentView.addSubview(notesLabel)
		notesLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		notesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
		notesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		notesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
	}
	
	override func configureCell(with item: ReminderItem) {
		notesLabel.text = item.reminder
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		notesLabel.text = nil
	}
}

// MARK: - Options Cell ?

// to do
