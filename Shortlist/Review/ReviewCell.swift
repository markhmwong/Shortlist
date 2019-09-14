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
class ReviewCell: UITableViewCell, UITextFieldDelegate {
    
    var task: Task? = nil {
        didSet {
            configure(with: task)
        }
    }
    
    //convert to textfield
    lazy var name: UITextField = {
        let label = UITextField()
        label.delegate = self
        label.keyboardType = UIKeyboardType.default
        label.keyboardAppearance = UIKeyboardAppearance.dark
        label.textColor = UIColor.white
        label.returnKeyType = UIReturnKeyType.done
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isEnabled = false
        return label
    }()
    
    lazy var taskButton: TaskButton = {
        let button = TaskButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTask), for: .touchUpInside)
        button.isEnabled = false
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
        taskButton.anchorView(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0), size: CGSize(width: 40.0, height: 0.0))
        name.anchorView(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: taskButton.trailingAnchor, trailing: contentView.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0), size: .zero)
    }
    
    func configure(with task: Task?) {
        
        if let task = task {
            name.attributedText = NSAttributedString(string: "\(task.name!)", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!])
            taskButton.taskState = task.complete
        } else {
            name.attributedText = NSAttributedString(string: "Unknown Task", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b0).value)!])
            taskButton.taskState = false
        }
        
    }
    
    func updateNameLabel(string: String) {
        DispatchQueue.main.async {
            self.name.attributedText = NSAttributedString(string: "\(string)", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b1).value)!])
        }
    }
    
    @objc
    func handleTask() {
        taskButton.taskState = !taskButton.taskState
        task?.complete = taskButton.taskState
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateTask(taskNameString: textField.text!)
        textField.resignFirstResponder()
        return true
    }
    
    func updateTask(taskNameString: String) {
        task!.name = taskNameString
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: .none)
    }
}



