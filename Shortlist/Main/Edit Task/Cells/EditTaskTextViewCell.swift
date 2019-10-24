//
//  EditTaskCell.swift
//  Shortlist
//
//  Created by Mark Wong on 23/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class EditTaskTextViewCell: EditTaskCellBase {

	typealias TaskName = String
	
	//updates string in view model
	var updateTaskString: ((TaskName, IndexPath) -> ())? = nil
	
    var persistentContainer: PersistentContainer?

	var details: String?
	
	var saveTask: ((TaskName) -> ())? = nil
	
	let size: CGFloat = Theme.Font.FontSize.Standard(.b0).value
	
	lazy var nameTextView: UITextView = {
        let view = UITextView()
        view.delegate = self
		view.backgroundColor = Theme.Cell.textFieldBackground
        view.keyboardType = UIKeyboardType.default
        view.keyboardAppearance = UIKeyboardAppearance.dark
		view.textColor = Theme.Font.Color
        view.returnKeyType = UIReturnKeyType.done
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textContainerInset = UIEdgeInsets.zero
        view.textContainer.lineFragmentPadding = 0
		view.isEditable = true
		view.isSelectable = true
		view.isUserInteractionEnabled = true
		view.isScrollEnabled = false
        return view
    }()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func setupCellLayout() {
		super.setupCellLayout()
		backgroundColor = .clear
        addSubview(nameTextView)
		nameTextView.anchorView(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 8.0, bottom: -10.0, right: -8.0), size: CGSize(width: 0, height: 0.0))
	}
	
	func configure(with text: String?) {
		if let text = text {
			let nameAttributedStr = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: size)!])
            nameTextView.attributedText = nameAttributedStr
		} else {
			let nameAttributedStr = NSMutableAttributedString(string: "unknown", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: size)!])
            nameTextView.attributedText = nameAttributedStr
		}
    }
    
    func saveTaskState() {
		saveTask?(nameTextView.text)
    }
	
	func updateTask(taskNameString: String) {
		let nameAttributedStr = NSMutableAttributedString(string: taskNameString, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: size)!])
		nameTextView.attributedText = nameAttributedStr
	 }
	
    override func prepareForReuse() {
        super.prepareForReuse()
		configure(with: .none)
    }
}

extension EditTaskTextViewCell: UITextViewDelegate {
    
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
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        // Resize the cell only when cell's size is changed
		
		guard let indexPath = tableView?.indexPath(for: self) else { return }
		updateTaskString?(textView.text ?? "", indexPath)
		
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
			if let thisIndexPath = tableView?.indexPath(for: self) {
                tableView?.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
    
}
