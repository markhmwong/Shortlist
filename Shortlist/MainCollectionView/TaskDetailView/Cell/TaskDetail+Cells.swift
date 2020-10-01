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
	
	// private variables
	private lazy var bodyLabel: UILabel = {
		let label = UILabel()
		label.font = ThemeV2.CellProperties.HeadingBoldFont
		label.textColor = ThemeV2.TextColor.DefaultColor
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
	
	private func setupViewAdditionalViews() {
		layer.cornerRadius = 5.0
		clipsToBounds = true
		
		// layout cell details
		let padding: CGFloat = 15.0
		
		contentView.addSubview(bodyLabel)
		
		bodyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0).isActive = true
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
}

// MARK: - Notes Cell
extension UICellConfigurationState {
	var notesItem: NotesItem? {
		set { self[.notesItem] = newValue }
		get { return self[.notesItem] as? NotesItem }
	}
}

fileprivate extension UIConfigurationStateCustomKey {
	static let notesItem = UIConfigurationStateCustomKey("com.whizbang.state.notes")
}

class TaskDetailNotesCell: BaseListCell<NotesItem> {
	
	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.notesItem = self.item
		return state
	}
	
	private func defaultListContentConfiguration() -> UIListContentConfiguration {
		return .subtitleCell()
	}
	
	private var viewConstraintCheck: NSLayoutConstraint? = nil

	private lazy var listContentView = UIListContentView(configuration: defaultListContentConfiguration())

//	private lazy var textColor: UIColor = ThemeV2.TextColor.DefaultColor
	
	private var highlight: CAShapeLayer = CAShapeLayer()
	
	private lazy var button: UIButton = {
		let button = UIButton()
		button.setTitle("Add Photo", for: .normal)
		button.setTitleColor(ThemeV2.TextColor.DefaultColor, for: .normal)
		button.addTarget(self, action: #selector(handleAddPhoto), for: .touchDown)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	private func setupViewsIfNeeded() {
		guard viewConstraintCheck == nil else { return }
		contentView.backgroundColor = ThemeV2.Background
		
		listContentView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(listContentView)
		contentView.layer.addSublayer(highlight)
		
		highlight.fillColor = UIColor.systemTeal.cgColor
		
		listContentView.backgroundColor = ThemeV2.Background
		listContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
		listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
		listContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
		
		// attach the bottom constraint so when the condition is met above the view isn't repeatedly attached to the cell
		viewConstraintCheck = listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		viewConstraintCheck?.isActive = true
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		highlight.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: rect.width * 0.01, height: rect.height)).cgPath
	}
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		setupViewsIfNeeded()
		var content = defaultListContentConfiguration().updated(for: state)
		content.textProperties.color = self.textColor
		content.textProperties.font = ThemeV2.CellProperties.PrimaryFont
		let emptyText = "Notes are empty"

		if (state.notesItem != nil) {
			if (state.notesItem?.isButton ?? false) {
				content.text = "Add Notes"
				highlight.fillColor = UIColor.clear.cgColor
			} else {
				content.text = "\(state.notesItem?.notes ?? emptyText)"
			}
		} else {
			content.text = emptyText
		}
		
		listContentView.configuration = content
	}
	
	@objc func handleAddPhoto() {
		print("Add Photo Button")
	}
}

// MARK: - Photo Cell
extension UICellConfigurationState {
	var photoItem: PhotoItem? {
		set { self[.photoItem] = newValue }
		get { return self[.photoItem] as? PhotoItem }
	}
}

fileprivate extension UIConfigurationStateCustomKey {
	static let photoItem = UIConfigurationStateCustomKey("com.whizbang.state.photo")
}

class TaskDetailPhotoCell: BaseListCell<PhotoItem> {
	
	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.photoItem = self.item
		return state
	}
	
//	private func defaultListContentConfiguration() -> UIListContentConfiguration {
//		return .subtitleCell()
//	}
	
//	private lazy var listContentView = UIListContentView(configuration: defaultListContentConfiguration())
	
	private var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private func setupViewsIfNeeded() {
		clipsToBounds = true
		layer.cornerRadius = self.bounds.height * 0.1
		contentView.backgroundColor = ThemeV2.Background

		contentView.addSubview(imageView)

		imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant:0).isActive = true
		imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
		imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
	}
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		setupViewsIfNeeded()
		
		guard let item = state.photoItem else {
			imageView.removeFromSuperview()
			return
		}
		
		if (item.isButton) {
			let config = UIImage.SymbolConfiguration(pointSize: 20.0)
			let image = UIImage(systemName: "camera.fill", withConfiguration: config)?.imageWithInsets(insets: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))?.withTintColor(ThemeV2.TextColor.DefaultColor)
			imageView.backgroundColor = ThemeV2.Background
			imageView.image = image
			imageView.contentScaleFactor = 0.5
		} else {
			if let photo = item.thumbnail {
				let p = UIImage(data: photo)
				imageView.image = p
			}
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
	}
}

// MARK: - Reminder Cell
class TaskDetailReminderCell: BaseCollectionViewCell<ReminderItem> {
	
	private let reminderLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.backgroundColor = .clear
		label.font = ThemeV2.CellProperties.HeadingBoldFont
		label.textColor = ThemeV2.TextColor.DefaultColor
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupCellViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		layer.cornerRadius = rect.height / 2
		layer.borderWidth = 4.0
		layer.borderColor = ThemeV2.TextColor.DefaultColor.cgColor
	}
	
	override func setupCellViews() {
		super.setupCellViews()
		
		contentView.addSubview(reminderLabel)
		
		reminderLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0.0).isActive = true
		reminderLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0.0).isActive = true
	}
	
	override func configureCell(with item: ReminderItem) {
		reminderLabel.text = "12:30pm"//item.reminder
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		reminderLabel.text = nil
	}
}
