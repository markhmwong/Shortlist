//
//  TaskCell.swift
//  Five
//
//  Created by Mark Wong on 20/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
	
    let minHeight: CGFloat = 70.0
    
	let categoryTextColor: UIColor = Theme.Font.Color.adjust(by: -10.0)!
	
    var persistentContainer: PersistentContainer?
    
    var task: Task? = nil {
        didSet {
            configure(with: task)
        }
    }
    
    var updateWatch: ((Task) -> ())? = nil
    
    var adjustDailyTaskComplete: ((Task) -> ())? = nil
    
	var updateStats: ((Task) -> ())? = nil
	    
	var isNew: Bool = false
	
	lazy var isEditable: Bool = false
	
    //convert to textfield
    lazy var taskName: UITextView = {
        let view = UITextView()
        view.delegate = self
        view.backgroundColor = .clear
        view.keyboardType = UIKeyboardType.default
        view.keyboardAppearance = UIKeyboardAppearance.dark
		view.textColor = UIColor.white.adjust(by: -50.0)
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
	
	var gradientLayer: CAGradientLayer = CAGradientLayer()
	
	let gradientOne = UIColor.white.withAlphaComponent(0.8).cgColor
	let gradientTwo = UIColor.white.cgColor
    let gradientThree = UIColor.white.withAlphaComponent(0.8).cgColor
	
	var gradientSet: [[CGColor]] = [[CGColor]]()
    var currentGradient: Int = 0
	
    lazy var details: UITextView = {
        let view = UITextView()
        view.delegate = self
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
    
    lazy var categoryTitle: UITextView = {
        let view = UITextView()
        view.delegate = self
		view.backgroundColor = UIColor.clear
        view.keyboardType = UIKeyboardType.default
        view.keyboardAppearance = UIKeyboardAppearance.dark
        view.textColor = UIColor.white
		view.layer.cornerRadius = 3.0
        view.returnKeyType = UIReturnKeyType.done
        view.textContainerInset = UIEdgeInsets.zero
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textContainerInset = UIEdgeInsets.zero
        view.textContainer.lineFragmentPadding = 0
		view.isEditable = isEditable
		view.isSelectable = isEditable
		view.isUserInteractionEnabled = isEditable
		view.isScrollEnabled = false
		view.tag = 1
        return view
    }()
    
    lazy var taskButton: TaskButton = {
        let button = TaskButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTask), for: .touchUpInside)
        return button
    }()
	
	lazy var priorityMarker: PriorityMarker = {
		let view = PriorityMarker()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
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
		fadedBackground.anchorView(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 2.0, left: 5.0, bottom: -2.0, right: -5.0), size: .zero)
		
	}
	
	override func layoutIfNeeded() {
		super.layoutIfNeeded()
		gradientLayer.frame = taskName.bounds
		priorityMarker.anchorView(top: contentView.topAnchor, bottom: nil, leading: contentView.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: contentView.bounds.width, height: 10.0))
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
		contentView.addSubview(priorityMarker)
		contentView.addSubview(details)
        contentView.addSubview(taskButton)


		taskButton.anchorView(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 20.0, left: 0.0, bottom: -20.0, right: 0.0), size: CGSize(width: 50.0, height: 0.0))
		taskName.anchorView(top: contentView.topAnchor, bottom: nil, leading: taskButton.trailingAnchor, trailing: contentView.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 20.0, left: 0.0, bottom: -5.0, right: -20.0), size: .zero)
		details.anchorView(top: taskName.bottomAnchor, bottom: categoryTitle.topAnchor, leading: taskButton.trailingAnchor, trailing: contentView.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 20.0, left: 0.0, bottom: -10.0, right: -20.0), size: .zero)
		categoryTitle.anchorView(top: nil, bottom: contentView.bottomAnchor, leading: taskName.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -2.0, right: 0.0), size: .zero)
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
        adjustDailyTaskComplete?(task)
		updateStats?(task)
		
        // save to core data
        saveTaskState()
		
		// sync with the watch
        updateWatch?(task)
        
        if (taskButton.taskState) {
            taskName.attributedText = NSAttributedString(string: "\(task.name!)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!])
        }
    }

    func configure(with task: Task?) {
        if let task = task {
			let nameStr = "\(task.name ?? "unknown")"
			let nameAttributedStr = NSMutableAttributedString(string: nameStr, attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!, ])
            
			let detailsStr = "\(task.details ?? "Empty Notes")"
			let detailsAttributedStr = NSMutableAttributedString(string: detailsStr, attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color.adjust(by: -40.0)!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b4).value)!])
			
            if (task.complete) {
                nameAttributedStr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, nameAttributedStr.length))
            }
            taskName.attributedText = nameAttributedStr
			details.attributedText = detailsAttributedStr
            taskButton.taskState = task.complete
				
			let categoryStr = "\(task.category)"

            let categoryAttributedStr = NSMutableAttributedString(string: categoryStr, attributes: [NSAttributedString.Key.foregroundColor : categoryTextColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b4).value)!])
			categoryTitle.attributedText = categoryAttributedStr
			
			if (task.isNew) {
				taskName.textColor = Theme.Font.Color.adjust(by: -40.0)!
				categoryTitle.textColor = UIColor.lightGray
			} else {
				taskName.textColor = Theme.Font.Color
				categoryTitle.textColor = categoryTextColor
			}
			
			priorityColor(task.priority)
        } else {
            taskName.attributedText = NSAttributedString(string: "Unknown Task", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!])
            taskButton.taskState = false
			priorityColor(3) // 3 is no color
        }
    }
	
	private func priorityColor(_ priorityLevel: Int16) {
		
		if let p = Priority.init(rawValue: priorityLevel) {
			switch p {
				case .high:
					fadedBackground.backgroundColor = Theme.Priority.highColor.withAlphaComponent(0.1)
					priorityMarker.updateGradient(color: Theme.Priority.highColor)
				case .medium:
					fadedBackground.backgroundColor = Theme.Priority.mediumColor.withAlphaComponent(0.1)
					priorityMarker.updateGradient(color: Theme.Priority.mediumColor)
				case .low:
					fadedBackground.backgroundColor = Theme.Priority.lowColor.withAlphaComponent(0.1)
					priorityMarker.updateGradient(color: Theme.Priority.lowColor)
				case .none:
					priorityMarker.updateGradient(color: Theme.Priority.noneColor)
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
	
	// not in use because we're no longer editing in place
	func stateOfTextView() {
		guard let task = task else { return }
		editingOfTaskName(task.isNew)
	}
	
	func editingOfTaskName(_ state: Bool) {
//		taskName.isEditable = state
//		taskName.isSelectable = state
//		taskName.isUserInteractionEnabled = state
//
//		categoryTitle.isEditable = state
//		categoryTitle.isSelectable = state
//		categoryTitle.isUserInteractionEnabled = state
	}
}

// no longer using cell with text input
extension TaskCell: UITextViewDelegate {
	
    var tableView: UITableView? {
        get {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }
            return table as? UITableView
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
			if (textView.superview?.viewWithTag(textView.tag + 1)) != nil {
	            updateTaskName(taskName: textView.text ?? "")
				setTaskToNotNew()
				saveTaskState()
				textView.textColor = UIColor.white
				return false
			} else {
				editingOfTaskName(false)
	            updateCategoryName(categoryName: textView.text ?? "") // may need to create a new category
				saveTaskState()
				textView.textColor = categoryTextColor
				return false
			}
		}

		if (textView.textColor == UIColor.lightGray) {
			textView.text = nil
			if (textView.tag == 1) {
				textView.textColor = UIColor.white
			}
		}
		
        return true
    }
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		saveTaskState()
	}
	
	func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		return false
	}
    
	// Using this method to alter the height of the textfield
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        // Resize the cell only when cell's size is changed
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            taskButton.setNeedsDisplay()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            if let thisIndexPath = tableView?.indexPath(for: self) {
                tableView?.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
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
