//
//  TaskDetailsView.swift
//  Shortlist
//
//  Created by Mark on 10/5/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit


class TaskDetailsViewController: UIViewController {
	
	private var viewModel: TaskDetailsViewModel
	
    private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.preferredFont(forTextStyle: .title1)
		label.text = "Title Placeholder"
		return label
	}()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.text = "13/7/2024"
        return label
    }()
    
    private lazy var completeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.text = "complete"
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
    
    lazy var imageView: UIImageView = {
        let image = UIImage(named: "")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // TODO: Add location
    /// map kit
    
    /// Category
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()

    /// Reminder
    private lazy var reminderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.preferredFont(forTextStyle: .body)
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
	
    init(viewModel: TaskDetailsViewModel, coordinator: TaskDetailsCoordinator) {
		self.viewModel = viewModel
        self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.white
		
		view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(completeLabel)
        view.addSubview(imageView)
        view.addSubview(categoryLabel)
        view.addSubview(reminderLabel)
        view.addSubview(completeButton)
        
        #if DEBUG
        view.addSubview(idLabel)
        #endif
        
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor, constant: 0),
			titleLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            completeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            completeLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            
            categoryLabel.topAnchor.constraint(equalTo: completeLabel.bottomAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: completeLabel.leadingAnchor),
            
            reminderLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor),
            reminderLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            
            imageView.topAnchor.constraint(equalTo: reminderLabel.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: reminderLabel.leadingAnchor),
            
            completeButton.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor),
            completeButton.centerXAnchor.constraint(equalTo: view.readableContentGuide.centerXAnchor),
            completeButton.heightAnchor.constraint(equalToConstant: 100),
            completeButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            completeButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
        ])
        
        #if DEBUG
        NSLayoutConstraint.activate([
            idLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 0),
            idLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ])
        #endif
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/mm/yy"
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .medium
        
        /// Populate labels and views from SLTask
		viewModel.item.bind { item in
			self.titleLabel.text = item.name
            self.dateLabel.text = dateformatter.string(from: item.taskToDay?.date ?? Date())
            self.formatCompleteLabel(item: item)
            self.categoryLabel.text = item.category
            self.reminderLabel.text = timeFormatter.string(from: item.reminder ?? Date())
            self.imageView.image = UIImage(named: "")
		}
	}
    
    @objc func handleComplete() {
        print("complete pressed")
        // dismiss
        // update complete task
        viewModel.taskIsComplete {
            // TODO: fast animation toggle
            // do some fancy animation
            // but also allow user to turn on/off fancy animations
            coordinator.dismissCurrentView()
        }
        
    }
    
    private func formatCompleteLabel(item: SLTask) {
        completeLabel.text = item.complete ? "Complete" : "Incomplete"
        completeButton.setTitle(!item.complete ? "Complete" : "Incomplete", for: .normal)
    }
}
