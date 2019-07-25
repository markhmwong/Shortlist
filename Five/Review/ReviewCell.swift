//
//  ReviewCell.swift
//  Five
//
//  Created by Mark Wong on 24/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell, UITextFieldDelegate {
    
    var task: Task? = nil {
        didSet {
            guard let taskName = task?.name else {
                print("didset")
                updateNameLabel(string: "Unknown name")
                return
            }
            
            if let state = task?.complete {
                taskButton.taskState = state
            }
            
            contentView.addSubview(name)
            contentView.addSubview(taskButton)
            
            taskButton.anchorView(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0), size: CGSize(width: bounds.width / 8, height: 0.0))
            name.anchorView(top: topAnchor, bottom: bottomAnchor, leading: taskButton.trailingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0), size: .zero)
            
            updateNameLabel(string: taskName)
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        CoreDataManager.shared.saveContext()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("did end")
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
        CoreDataManager.shared.saveContext()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name.removeFromSuperview()
        taskButton.removeFromSuperview()
    }
}



