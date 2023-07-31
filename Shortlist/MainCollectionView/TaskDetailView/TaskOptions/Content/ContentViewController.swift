//
//  ContentViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 23/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

enum TaskContentEditable {
	case title
	case notes
	case newNote
}

class ContentViewControllerA<T>: UIViewController, UITextViewDelegate {
	
	private var text: T
	
	init(text: T) {
		self.text = text
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
}

// MARK: - Content View Controller
// Edit written content
class ContentViewController: UIViewController, UITextViewDelegate {
	
	private var maxLimit = 0
	
	private var editType: TaskContentEditable
	
	private var task: Task {
		didSet {
			self.dataView.text = "\(task)"
		}
	}
	
	private var taskNote: TaskNote? = nil
	
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
	
	private var persistentContainer: PersistentContainer
	
	private var coordinator: Coordinator
	
    private var isModal: Bool
    
    init(editType: TaskContentEditable, task: Task, taskNote: TaskNote? = nil, persistentContainer: PersistentContainer, coordinator: Coordinator, modal: Bool = false) {
		self.coordinator = coordinator
		self.persistentContainer = persistentContainer
		self.editType = editType
		self.task = task
		self.taskNote = taskNote
        self.isModal = modal
		super.init(nibName: nil, bundle: nil)
		
		// update UI label and limits as limits are different for Title names and Notes
		switch editType {
			case .title:
				titleLabel.text = "A QUALITY TITLE" // static text
				dataView.text = task.name
				maxLimit = CharacterLimitConstants.titleLimit
			case .notes:
				titleLabel.text = "QUICK NOTE" // static text
				dataView.text = taskNote?.note ?? "Unknown Note"
				maxLimit = CharacterLimitConstants.noteLimit
			case .newNote:
				titleLabel.text = "QUICK NOTE" // static text
				dataView.text = taskNote?.note ?? "Unknown Note"
				maxLimit = CharacterLimitConstants.noteLimit
		}
		updateCharacterLimit()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// keyboard
		
		// navigation
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
		dataView.becomeFirstResponder()
        
        if isModal {
            dataView.isEditable = false
            view.backgroundColor = .clear
            addBlurToViewController()
            
            let smallView = UIView()
            smallView.backgroundColor = .clear//ThemeV2.Background
            smallView.layer.cornerRadius = 10.0
            smallView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(smallView)
            smallView.addSubview(titleLabel)
            smallView.addSubview(dataView)
            smallView.addSubview(characterLimit)
            
            smallView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20).isActive = true
            smallView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20).isActive = true
            smallView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 200).isActive = true
            smallView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -200).isActive = true
            
            // static title
            titleLabel.topAnchor.constraint(equalTo: smallView.layoutMarginsGuide.topAnchor, constant: 10.0).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: smallView.layoutMarginsGuide.leadingAnchor).isActive = true
            
            // the actual note
            dataView.contentInset = .zero
            dataView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0).isActive = true
            dataView.leadingAnchor.constraint(equalTo: smallView.layoutMarginsGuide.leadingAnchor).isActive = true
            dataView.trailingAnchor.constraint(equalTo: smallView.layoutMarginsGuide.trailingAnchor).isActive = true
            dataView.bottomAnchor.constraint(equalTo: smallView.bottomAnchor).isActive = true
            
            characterLimit.topAnchor.constraint(equalTo: dataView.bottomAnchor).isActive = true
            characterLimit.trailingAnchor.constraint(equalTo: dataView.trailingAnchor).isActive = true
        } else {
            view.addSubview(dataView)
            view.addSubview(titleLabel)
            view.addSubview(characterLimit)
            
            view.backgroundColor = ThemeV2.Background
            titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10.0).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
            
            dataView.contentInset = .zero
            dataView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0).isActive = true
            dataView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
            dataView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
            dataView.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
            characterLimit.topAnchor.constraint(equalTo: dataView.bottomAnchor).isActive = true
            characterLimit.trailingAnchor.constraint(equalTo: dataView.trailingAnchor).isActive = true
        }
	}
    
    func addBlurToViewController() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
	
	@objc func handleSave() {
		// save based on edit Type
		switch editType {
			case .title:
				if !dataView.text.isEmpty {
					task.name = dataView.text
				}
			case .notes:
				guard let taskNote = taskNote else { return }
				taskNote.note = dataView.text
			case .newNote:
				guard let taskNote = taskNote else { return }
				taskNote.note = dataView.text
				task.addToTaskToNotes(taskNote)
		}
        let date = Date()
        task.taskToDay?.updatedAt = date as NSDate
		task.updateAt = date
		persistentContainer.saveContext()
		coordinator.dismissCurrentView()
	}
	
	private func updateCharacterLimit() {
		let currCount: Int = dataView.text.count
		let limit = (maxLimit - currCount)
		formatCharacterLimit("\(limit)")
	}
	
	private func formatCharacterLimit(_ text: String) {
		characterLimit.text = text
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
				
		switch editType {
			case .title:
				maxLimit = CharacterLimitConstants.titleLimit
			case .notes:
				()
			default:
				maxLimit = CharacterLimitConstants.noteLimit
		}
		
		let currCount = textView.text.count + (text.count - range.length)
		if currCount <= maxLimit {
			updateCharacterLimit()
			return true
		} else {
			return false
		}
	}
	
}





