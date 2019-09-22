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
    
    var persistentContainer: PersistentContainer?
    
    var task: Task? = nil {
        didSet {
            configure(with: task)
        }
    }
    
    var updateWatch: ((Task) -> ())? = nil
    
    var adjustDailyTaskComplete: ((Task) -> ())? = nil
    
    var stateColor: UIColor?
    
    //convert to textfield
    lazy var name: UITextView = {
        let view = UITextView()
        view.delegate = self
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.keyboardType = UIKeyboardType.default
        view.keyboardAppearance = UIKeyboardAppearance.dark
        view.textColor = UIColor.white
        view.returnKeyType = UIReturnKeyType.done
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textContainerInset = UIEdgeInsets.zero
        view.textContainer.lineFragmentPadding = 0
		view.isEditable = false
        return view
    }()
    
    lazy var categoryTitle: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "Work", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color.adjust(by: -40.0)!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b3).value)!])
        view.translatesAutoresizingMaskIntoConstraints = false
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
        setupCellLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellLayout() {
        backgroundColor = .clear
        
        contentView.addSubview(name)
        contentView.addSubview(taskButton)
        contentView.addSubview(categoryTitle)
        
        taskButton.anchorView(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0), size: CGSize(width: 40.0, height: 0.0))
        name.anchorView(top: contentView.topAnchor, bottom: categoryTitle.topAnchor, leading: taskButton.trailingAnchor, trailing: contentView.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 4.0, left: 10.0, bottom: 0.0, right: 0.0), size: .zero)
        categoryTitle.anchorView(top: nil, bottom: contentView.bottomAnchor, leading: name.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -5.0, right: 0.0), size: .zero)
    }

    func updateNameLabel(string: String) {
        DispatchQueue.main.async {
            self.name.attributedText = NSAttributedString(string: "\(string)", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!])
        }
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
            name.attributedText = NSAttributedString(string: "\(task.name!)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!])
        }
    }

    func configure(with task: Task?) {
        if let task = task {
            stateColor = task.complete ? UIColor.white.darker(by: 40.0) : UIColor.white
            let nameStr = "\(task.name!)"
            let nameAttributedStr = NSMutableAttributedString(string: nameStr, attributes: [NSAttributedString.Key.foregroundColor : stateColor!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!])
            
            if task.complete {
                nameAttributedStr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, nameAttributedStr.length))
            }
            name.attributedText = nameAttributedStr
            taskButton.taskState = task.complete
        } else {
            name.attributedText = NSAttributedString(string: "Unknown Task", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!])
            taskButton.taskState = false
        }
        
    }

    func updateTask(taskNameString: String) {
        task!.name = taskNameString
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
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        return CGSize(width: size.width, height: max(size.height, minHeight))
    }
}

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
            updateTask(taskNameString: textView.text!)
            saveTaskState()
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
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
