//
//  TaskDetailsView.swift
//  Shortlist
//
//  Created by Mark on 10/5/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

class TaskDetailsViewController: UIViewController, UITextViewDelegate {

	private struct ViewConstants {
		static let spacing: CGFloat = 5.0
	}


	private var viewModel: TaskDetailsViewModel
	
    private lazy var titleTextView: UITextView = {
		let textView = UITextView()
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.font = UIFont.preferredFont(forTextStyle: .title1)
		textView.text = "Title Placeholder"
		textView.isEditable = true
		textView.isScrollEnabled = false // Disable scrolling
		textView.keyboardDismissMode = .interactiveWithAccessory
		textView.inputAccessoryView = createToolbar()
		textView.delegate = self
		return textView
	}()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.text = "13/7/2024"
        return label
    }()
    
    #if DEBUG
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.text = "id"
        return label
    }()
    #endif

	/// attached images (probably should be a collection view
    lazy var imageView: UIImageView = {
        let image = UIImage(named: "")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // TODO: Add location
    /// map kit
    
    /// Category
	private lazy var categoryLabel: PaddedIconTextLabel = {
		let label = PaddedIconTextLabel(iconName: AssetManager.PresetCategoryAssets.general.iconName, text: "", textStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

	private lazy var reminderLabel: PaddedIconTextLabel = {
		let label = PaddedIconTextLabel(iconName: AssetManager.OtherAssets.alarm.iconName, text: "", textStyle: .caption1)
		return label
	}()

    private lazy var completeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "complete"
        config.baseForegroundColor = .black
        config.baseBackgroundColor = .gray
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleComplete), for: .touchUpInside)
        return button
    }()

    private var coordinator: TaskDetailsCoordinator
	
    public var delegate: Refreshable

    init(viewModel: TaskDetailsViewModel, coordinator: TaskDetailsCoordinator, delegate: Refreshable) {
		self.viewModel = viewModel
        self.coordinator = coordinator
        self.delegate = delegate
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupLayout() {
		view.addSubview(titleTextView)
		view.addSubview(dateLabel)
		view.addSubview(imageView)
		view.addSubview(categoryLabel)
		view.addSubview(reminderLabel)
		view.addSubview(completeButton)

#if DEBUG
		view.addSubview(idLabel)
#endif

		NSLayoutConstraint.activate([
			titleTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 0),
			titleTextView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
			titleTextView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),

			dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			dateLabel.bottomAnchor.constraint(equalTo: titleTextView.topAnchor),
			dateLabel.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor),

			categoryLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor),
			categoryLabel.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor),

			reminderLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: ViewConstants.spacing),
			reminderLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),

			completeButton.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor),
			completeButton.centerXAnchor.constraint(equalTo: view.readableContentGuide.centerXAnchor),
			completeButton.heightAnchor.constraint(equalToConstant: 100),
			completeButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
			completeButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
		])

		// Add a height constraint with a low priority
		let heightConstraint = titleTextView.heightAnchor.constraint(equalToConstant: 10)
		heightConstraint.priority = .defaultLow
		heightConstraint.isActive = true

#if DEBUG
		NSLayoutConstraint.activate([
			idLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 0),
			idLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
		])
#endif
	}

	public func dismissCurrentView() {
		delegate.refresh(item: viewModel.item.value)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.white

		setupLayout()

		// Adjust height based on content size
		textViewDidChange(titleTextView)

        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/mm/yy"
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .medium
        
        /// Populate labels and views from SLTask
		viewModel.item.bind { item in
			self.titleTextView.text = item.name
            self.dateLabel.text = dateformatter.string(from: item.createdAt ?? Date())
            self.formatCompleteLabel(item: item)
			self.categoryLabel.updateText(text: item.taskToCategory?.name ?? "Unknown Category")
			let timeStr = timeFormatter.string(from: item.reminder ?? Date())
			self.reminderLabel.updateText(text: timeStr)
            self.imageView.image = UIImage(named: "")
		}
	}
    
    @objc func handleComplete() {
        print("complete pressed")
        // dismiss
        // update complete task
        viewModel.taskIsComplete { item in
			/// save
			viewModel.save(title: titleTextView.text)

            // refresh the TaskListViewController
            // TODO: fast animation toggle
            // do some fancy animation
            // but also allow user to turn on/off fancy animations
            coordinator.dismissCurrentView()
            delegate.refresh(item: item)
        }
    }
    
    private func formatCompleteLabel(item: SLTask) {
        print(item.taskToStatus?.name ?? "")
        completeButton.setTitle(item.taskToStatus?.name, for: .normal)
    }

	// MARK: Title Text View
	// UITextViewDelegate method to adjust the height dynamically
	func textViewDidChange(_ textView: UITextView) {
		let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude))
		textView.constraints.forEach { constraint in
			if constraint.firstAttribute == .height {
				constraint.constant = size.height
			}
		}
	}

	// Create a toolbar with a Done button
	private func createToolbar() -> UIToolbar {
		let toolbar = UIToolbar()
		toolbar.sizeToFit()

		// Add a Done button
		let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
		toolbar.items = [doneButton]

		return toolbar
	}

	// Dismiss the keyboard
	@objc private func dismissKeyboard() {
		// save
		viewModel.save(title: titleTextView.text)

		titleTextView.endEditing(true)
	}
}
