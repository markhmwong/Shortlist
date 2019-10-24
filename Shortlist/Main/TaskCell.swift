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
    
	let categoryTextColor: UIColor = Theme.Font.Color.adjust(by: -30.0)!
	
    var persistentContainer: PersistentContainer?
    
    var task: Task? = nil {
        didSet {
            configure(with: task)
        }
    }
    
    var updateWatch: ((Task) -> ())? = nil
    
    var adjustDailyTaskComplete: ((Task) -> ())? = nil
    
    var stateColor: UIColor?
    
	var isNew: Bool = false
	
	lazy var isEditable: Bool = false
	
    //convert to textfield
    lazy var taskName: UITextView = {
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
        view.backgroundColor = .clear
        view.keyboardType = UIKeyboardType.default
        view.keyboardAppearance = UIKeyboardAppearance.dark
        view.textColor = UIColor.white
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupCellLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	func setupCellLayout(_ row: Int) {
        backgroundColor = .clear
        
        contentView.addSubview(taskName)
        contentView.addSubview(taskButton)
        contentView.addSubview(categoryTitle)
		
		taskButton.anchorView(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0), size: CGSize(width: 40.0, height: 0.0))
        taskName.anchorView(top: contentView.topAnchor, bottom: categoryTitle.topAnchor, leading: taskButton.trailingAnchor, trailing: contentView.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 3.0, left: 10.0, bottom: 0.0, right: 0.0), size: .zero)
		categoryTitle.anchorView(top: nil, bottom: contentView.bottomAnchor, leading: taskName.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -5.0, right: 0.0), size: .zero)
	}
    
    @objc
    func handleTask() {
        taskButton.taskState = !taskButton.taskState
		
        guard let task = task else { return }
        task.complete = taskButton.taskState
        adjustDailyTaskComplete?(task)
        // save to core data
        saveTaskState()
        updateWatch?(task)
        
        if (taskButton.taskState) {
            taskName.attributedText = NSAttributedString(string: "\(task.name!)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!])
        }
    }

    func configure(with task: Task?) {
        if let task = task {
            stateColor = task.complete ? UIColor.white.darker(by: 40.0) : UIColor.white
			let nameStr = "\(task.name ?? "unknown")"
            let nameAttributedStr = NSMutableAttributedString(string: nameStr, attributes: [NSAttributedString.Key.foregroundColor : stateColor!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!])
            
            if task.complete {
                nameAttributedStr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, nameAttributedStr.length))
            }
            taskName.attributedText = nameAttributedStr
            taskButton.taskState = task.complete
				
			let categoryStr = "\(task.category)"

            let categoryAttributedStr = NSMutableAttributedString(string: categoryStr, attributes: [NSAttributedString.Key.foregroundColor : categoryTextColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b4).value)!])
			categoryTitle.attributedText = categoryAttributedStr
			
			if (task.isNew) {
				taskName.textColor = UIColor.lightGray
				categoryTitle.textColor = UIColor.lightGray
			} else {
				taskName.textColor = UIColor.white
				categoryTitle.textColor = categoryTextColor
			}
        } else {
            taskName.attributedText = NSAttributedString(string: "Unknown Task", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!])
            taskButton.taskState = false
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
	
	func stateOfTextView() {
		guard let task = task else { return }
		editingOfTaskName(task.isNew)
	}
	
	func editingOfTaskName(_ state: Bool) {
		taskName.isEditable = state
		taskName.isSelectable = state
		taskName.isUserInteractionEnabled = state
		
		categoryTitle.isEditable = state
		categoryTitle.isSelectable = state
		categoryTitle.isUserInteractionEnabled = state
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
			if let nextField = textView.superview?.viewWithTag(textView.tag + 1) {
	            updateTaskName(taskName: textView.text ?? "")
				setTaskToNotNew()
				saveTaskState()
				textView.textColor = UIColor.white
//				nextField.becomeFirstResponder()
				return false
			} else {
				editingOfTaskName(false)
	            updateCategoryName(categoryName: textView.text ?? "") // may need to create a new category
				saveTaskState()
				textView.textColor = categoryTextColor
//				textView.resignFirstResponder()
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
		if let nextField = textView.superview?.viewWithTag(textView.tag + 1) {
//			nextField.becomeFirstResponder()
			return false
		}
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
