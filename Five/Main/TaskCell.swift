//
//  TaskCell.swift
//  Five
//
//  Created by Mark Wong on 20/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
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
            
            taskButton.anchorView(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0), size: CGSize(width: 40.0, height: 0.0))
            name.anchorView(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: taskButton.trailingAnchor, trailing: contentView.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0), size: .zero)
            
            updateNameLabel(string: taskName)
        }
    }
    
    //convert to textfield
    lazy var name: UITextView = {
        let view = UITextView()
        view.delegate = self
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.keyboardType = UIKeyboardType.default
        view.keyboardAppearance = UIKeyboardAppearance.dark
        view.textColor = UIColor.white
        view.returnKeyType = UIReturnKeyType.default
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
//        CoreDataManager.shared.saveContext()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name.removeFromSuperview()
        taskButton.removeFromSuperview()
    }
    

    
    func updateTask(taskNameString: String) {
        task!.name = taskNameString
//        CoreDataManager.shared.saveContext()
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
    
    private func textViewDidEndEditing(_ textField: UITextField) {
        print("did end")
    }
    
    private func textViewShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    //    func textViewShouldReturn(_ textField: UITextField) -> Bool {
    //        updateTask(taskNameString: textField.text!)
    //        textField.resignFirstResponder()
    //        return true
    //    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
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
