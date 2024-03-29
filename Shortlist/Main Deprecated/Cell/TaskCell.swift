//
//  TaskCell.swift
//  Five
//
//  Created by Mark Wong on 20/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
	    
	let categoryTextColor: UIColor = Theme.Font.DefaultColor
	
    var persistentContainer: PersistentContainer?
    
    var task: Task? = nil {
        didSet {
            configure(with: task)
        }
    }
	
    var updateReminder: ((Task) -> ())? = nil
    
    var updateWatch: ((Task) -> ())? = nil
    
    var updateDailyStats: ((Task) -> ())? = nil
    
	var updateStats: ((Task) -> ())? = nil
	   
	var updateBackLog: ((Task) -> ())? = nil
	
	var isNew: Bool = false
	
	private let isEditable: Bool = false
	
	lazy var reminderLabel: UILabel = {
        let label = UILabel()
		label.text = ""
		label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.Font.DefaultColor.adjust(by: 10)!
        return label
	}()
    
    lazy var taskName: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.keyboardType = UIKeyboardType.default
        view.keyboardAppearance = UIKeyboardAppearance.dark
		view.textColor = Theme.Font.DefaultColor.adjust(by: -50.0)
        view.returnKeyType = UIReturnKeyType.done
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textContainerInset = UIEdgeInsets.zero
        view.textContainer.lineFragmentPadding = 0
		view.isEditable = isEditable
		view.isSelectable = isEditable
		view.isUserInteractionEnabled = isEditable
		view.isScrollEnabled = false
		view.tag = 0
        return view
    }()
	
    lazy var shinyTaskName: UIView = {
        let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .yellow
        return view
    }()
	
	private var gradientLayer: CAGradientLayer = CAGradientLayer()
	
	private let gradientOne = UIColor.white.withAlphaComponent(0.8).cgColor
	private let gradientTwo = UIColor.white.cgColor
    private let gradientThree = UIColor.white.withAlphaComponent(0.8).cgColor
	
	private var gradientSet: [[CGColor]] = [[CGColor]]()
    private var currentGradient: Int = 0
	
    lazy var details: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.keyboardType = UIKeyboardType.default
        view.keyboardAppearance = UIKeyboardAppearance.dark
        view.textColor = UIColor.white
        view.returnKeyType = UIReturnKeyType.done
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textContainerInset = UIEdgeInsets.zero
        view.textContainer.lineFragmentPadding = 0
		view.isEditable = isEditable
		view.isSelectable = isEditable
		view.isUserInteractionEnabled = isEditable
		view.isScrollEnabled = false
		view.tag = 0
        return view
    }()

    lazy var categoryTitle: TagLabel = {
        let view = TagLabel(bgColor: Theme.Cell.categoryBackground)
        view.textColor = Theme.Font.DefaultColor
		view.tag = 1
        return view
    }()
	
//    lazy var categoryTitle: UILabel = {
//        let view = UILabel()
//		view.backgroundColor = UIColor.clear
//        view.textColor = Theme.Font.DefaultColor
//		view.layer.cornerRadius = 4.0
//		view.layer.backgroundColor = Theme.Cell.categoryBackground.cgColor
//        view.translatesAutoresizingMaskIntoConstraints = false
//		view.tag = 1
//        return view
//    }()
    
    lazy var taskButton: TaskButton = {
        let button = TaskButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTask), for: .touchUpInside)
        return button
    }()
	
	lazy var fadedBackground: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	override func layoutSubviews() {
		super.layoutSubviews()
		configure(with: task)
	}
	
	override func layoutIfNeeded() {
		super.layoutIfNeeded()
		gradientLayer.frame = taskName.bounds
		fadedBackground.anchorView(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 2.0, left: 5.0, bottom: -2.0, right: -5.0), size: .zero)
	}
	
	
	func setupCellLayout() {
		contentView.addSubview(fadedBackground)
		backgroundColor = .clear
		gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
		gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
		gradientLayer.drawsAsynchronously = true
		
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])
		gradientLayer.colors = gradientSet[currentGradient]
		gradientLayer.delegate = self // animation
		animateGradient()
		taskName.layer.mask = gradientLayer
        contentView.addSubview(taskName)
        contentView.addSubview(categoryTitle)
		contentView.addSubview(details)
        contentView.addSubview(taskButton)
		contentView.addSubview(reminderLabel)
		
		taskButton.anchorView(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 20.0, left: 0.0, bottom: -20.0, right: 0.0), size: CGSize(width: 50.0, height: 0.0))
		taskName.anchorView(top: contentView.topAnchor, bottom: nil, leading: taskButton.trailingAnchor, trailing: contentView.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 20.0, left: 0.0, bottom: -5.0, right: -20.0), size: .zero)
		details.anchorView(top: taskName.bottomAnchor, bottom: categoryTitle.topAnchor, leading: taskButton.trailingAnchor, trailing: contentView.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 20.0, left: 0.0, bottom: -10.0, right: -20.0), size: .zero)
		categoryTitle.anchorView(top: nil, bottom: contentView.bottomAnchor, leading: taskName.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 5.0, bottom: -5.0, right: -5.0), size: .zero)
//		categoryTitle.textContainerInset = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
		reminderLabel.anchorView(top: nil, bottom: contentView.bottomAnchor, leading: categoryTitle.trailingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: -5.0, right: 0.0), size: .zero)
	}
	
    func animateGradient() {
        if (currentGradient < gradientSet.count - 1) {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
		gradientChangeAnimation.delegate = self
		gradientChangeAnimation.timingFunction = .init(name: .linear)
		gradientChangeAnimation.duration = 1.5
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
		gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientLayer.add(gradientChangeAnimation, forKey: "colorChange")
    }
    
    @objc
    func handleTask() {
        taskButton.taskState = !taskButton.taskState
		
        guard let task = task else { return }
        task.complete = taskButton.taskState
        updateDailyStats?(task)
		updateStats?(task)
		updateBackLog?(task)
        // save to core data
        saveTaskState()
		
		// sync with the watch
        updateWatch?(task)
		
		// update Reminder
        updateReminder?(task)
		
		contentView.alpha = task.complete ? 0.7 : 1.0
    }

    func configure(with task: Task?) {
        if let task = task {
			let nameStr = "\(task.name ?? "unknown")"
			
			let nameAttributedStr = NSMutableAttributedString(string: nameStr, attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!])
            
			let detailsStr = "\(task.details ?? "Empty Notes")"
			let detailsAttributedStr = NSMutableAttributedString(string: detailsStr, attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor.adjust(by: -40.0)!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b4).value)!])
			self.contentView.alpha = 1.0

            taskName.attributedText = nameAttributedStr
			details.attributedText = detailsAttributedStr
            taskButton.taskState = task.complete
			contentView.alpha = task.complete ? 0.7 : 1.0
			
			let categoryStr = "\(task.category ?? "Unknown")"
			
			let categoryAttributedStr = NSMutableAttributedString(string: categoryStr, attributes: [NSAttributedString.Key.foregroundColor : categoryTextColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b4).value)!])
			categoryTitle.attributedText = categoryAttributedStr
			
			let reminderDate = task.reminder ?? Date()
			let reminderStr = (reminderDate as Date).timeToStringInHrMin()
			
			if (task.reminderState) {
				reminderLabel.attributedText = NSMutableAttributedString(string: "⏰ \(reminderStr)", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor.adjust(by: -40.0)!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b4).value)!])
			} else {
				reminderLabel.text = ""
			}

			priorityColor(task.priority)
        } else {
            taskName.attributedText = NSAttributedString(string: "Unknown Task", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!])
            taskButton.taskState = false
			priorityColor(3) // 3 is no color
        }
    }
	
	private func priorityColor(_ priorityLevel: Int16) {
		if let p = Priority.init(rawValue: priorityLevel) {
			switch p {
				case .high:
					fadedBackground.backgroundColor = Theme.Priority.highColor.withAlphaComponent(0.1)
				case .medium:
					fadedBackground.backgroundColor = Theme.Priority.mediumColor.withAlphaComponent(0.1)
				case .low:
					fadedBackground.backgroundColor = Theme.Priority.lowColor.withAlphaComponent(0.1)
				case .none:
					()
			}
		}
	}

    func updateTaskName(taskName: String) {
        task!.name = taskName
    }
	
	func updateCategoryName(categoryName: String) {
		task!.category = categoryName
	}
	
	func setTaskToNotNew() {
		task!.isNew = false
	}
    
    func saveTaskState() {
        if let pc = persistentContainer {
            pc.saveContext()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: .none)
    }
}


extension TaskCell: CAAnimationDelegate {
	func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradientLayer.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}
