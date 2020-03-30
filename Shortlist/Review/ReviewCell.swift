//
//  ReviewCell.swift
//  Five
//
//  Created by Mark Wong on 24/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

// Same ask task cell practically however all user interaction is disabled; the editing and button
// the cell will act as a preview of yesterday's tasks.
class ReviewCell: UITableViewCell {
    
    let minHeight: CGFloat = 70.0
    
    var persistentContainer: PersistentContainer?
    
    var task: Task? = nil {
        didSet {
            configure(with: task)
        }
    }
	
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
	
	var carryTaskOver: ((Task) -> ())? = nil
	
    //convert to textfield
    lazy var name: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.keyboardType = UIKeyboardType.default
        view.keyboardAppearance = UIKeyboardAppearance.dark
        view.textColor = Theme.Font.DefaultColor
        view.returnKeyType = UIReturnKeyType.done
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textContainerInset = UIEdgeInsets.zero
        view.textContainer.lineFragmentPadding = 0
        view.isEditable = false
		view.isSelectable = false
		view.isUserInteractionEnabled = false
        return view
    }()
	
    lazy var details: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.keyboardType = UIKeyboardType.default
        view.keyboardAppearance = UIKeyboardAppearance.dark
        view.textColor = Theme.Font.DefaultColor
        view.returnKeyType = UIReturnKeyType.done
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textContainerInset = UIEdgeInsets.zero
        view.textContainer.lineFragmentPadding = 0
		view.isEditable = false
		view.isSelectable = false
		view.isUserInteractionEnabled = false
		view.isScrollEnabled = false
		view.tag = 0
        return view
    }()
    
	// Color of text dependent on the completion state of the task
	var stateColor: UIColor?
	
    lazy var categoryTitle: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "Work", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor.adjust(by: -40.0)!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b3).value)!])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var taskButton: TaskButton = {
        let button = TaskButton()
		button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTask), for: .touchUpInside)
        return button
    }()
	
	var selectedState: Bool = false {
		didSet {
			if selectedState {
				UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
					self.contentView.backgroundColor = Theme.Cell.highlighted
				}, completion: nil)
			} else {
				UIView.animate(withDuration: 0.05, delay: 0.0, options: [.curveEaseInOut], animations: {
					self.contentView.backgroundColor = .clear
				}, completion: nil)
			}
			guard let t = task else { return }
			self.isSelected = selectedState
			print(t.name)
			carryTaskOver?(t)
		}
	}
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellAndLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellAndLayout() {
        backgroundColor = .clear
		selectionStyle = .none
		
		contentView.addSubview(fadedBackground)
        contentView.addSubview(name)
        contentView.addSubview(taskButton)
        contentView.addSubview(categoryTitle)
		contentView.addSubview(priorityMarker)
		contentView.addSubview(details)

        taskButton.anchorView(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0), size: CGSize(width: 40.0, height: 0.0))
        name.anchorView(top: contentView.topAnchor, bottom: nil, leading: taskButton.trailingAnchor, trailing: contentView.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 20.0, left: 10.0, bottom: 0.0, right: 0.0), size: .zero)
		details.anchorView(top: name.bottomAnchor, bottom: categoryTitle.topAnchor, leading: name.leadingAnchor, trailing: contentView.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 20.0, left: 0.0, bottom: -10.0, right: -20.0), size: .zero)
        categoryTitle.anchorView(top: nil, bottom: contentView.bottomAnchor, leading: name.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -5.0, right: 0.0), size: .zero)
    }
	
	override func layoutIfNeeded() {
		super.layoutIfNeeded()
		priorityMarker.anchorView(top: contentView.topAnchor, bottom: nil, leading: contentView.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: contentView.bounds.width, height: 10.0))
		fadedBackground.anchorView(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 2.0, left: 5.0, bottom: -2.0, right: -5.0), size: .zero)

	}
    
    func updateNameLabel(string: String) {
        DispatchQueue.main.async {
            self.name.attributedText = NSAttributedString(string: "\(string)", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!])
        }
    }
    
	// button is disabled 20092019
    @objc
    func handleTask() {

    }
    
    func configure(with task: Task?) {
        if let task = task {
            stateColor = task.complete ? Theme.Font.DefaultColor.darker(by: 40.0) : Theme.Font.DefaultColor
            let nameStr = "\(task.name!)"
            let nameAttributedStr = NSMutableAttributedString(string: nameStr, attributes: [NSAttributedString.Key.foregroundColor : stateColor!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!])
            
			let detailsStr = "\(task.details ?? "Empty Notes")"
			let detailsAttributedStr = NSMutableAttributedString(string: detailsStr, attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor.adjust(by: -40.0)!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b4).value)!])
			
            name.attributedText = nameAttributedStr
			details.attributedText = detailsAttributedStr

            taskButton.taskState = task.complete
			priorityColor(task.priority)
        } else {
            name.attributedText = NSAttributedString(string: "Task Error", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!])
            taskButton.taskState = false
			priorityColor(3) // 3 is no color
        }
    }
    
    func updateTaskName(taskNameString: String) {
        task!.name = taskNameString
    }
    
    func saveTaskState() {
        if let pc = persistentContainer {
            pc.saveContext()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: .none)
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        return CGSize(width: size.width, height: max(size.height, minHeight))
    }
}
