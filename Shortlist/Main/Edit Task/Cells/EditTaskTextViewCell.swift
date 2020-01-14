//
//  EditTaskCell.swift
//  Shortlist
//
//  Created by Mark Wong on 23/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

enum EditTaskTextViewType: Int {
	case Name
	case Details
	case Category
}

class EditTaskTextViewCell: CellBase {

	typealias TaskName = String
	
	//updates string in view model
	var updateTaskString: ((TaskName, IndexPath) -> ())? = nil
	
    weak var persistentContainer: PersistentContainer?

	private var details: String?
	
	var size: CGFloat = Theme.Font.FontSize.Standard(.b0).value
	
	lazy var inputTextView: UITextView = {
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
		view.layer.cornerRadius = 3.0
		view.isEditable = true
		view.isSelectable = true
		view.isUserInteractionEnabled = true
		view.isScrollEnabled = false
        return view
    }()
	
	lazy var progressBarContainer: ProgressBarContainer = {
		let view = ProgressBarContainer()
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellLayout()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func setupCellLayout() {
		super.setupCellLayout()
		let backgroundView = UIView()
		backgroundView.backgroundColor = .clear
		selectedBackgroundView = backgroundView
		backgroundColor = .clear
		
        addSubview(inputTextView)
		addSubview(progressBarContainer)
		
		inputTextView.anchorView(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 8.0, bottom: -10.0, right: -8.0), size: CGSize(width: 0, height: 0.0))
		progressBarContainer.anchorView(top: inputTextView.topAnchor, bottom: nil, leading: nil, trailing: inputTextView.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -5.0), size: CGSize(width: 18.0, height: 18.0))
		
		progressBarContainer.updateColor(0.0)
		progressBarContainer.updateProgressBar(0.0)
	}
	
	func configure(with text: String?) {
		if let text = text {
			let nameAttributedStr = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: size)!])
            inputTextView.attributedText = nameAttributedStr
		} else {
			let nameAttributedStr = NSMutableAttributedString(string: "unknown", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: size)!])
            inputTextView.attributedText = nameAttributedStr
		}
    }
	
	func updateTask(taskNameString: String) {
		let nameAttributedStr = NSMutableAttributedString(string: taskNameString, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: size)!])
		inputTextView.attributedText = nameAttributedStr
		determineProgressBar(count: taskNameString.count)
	 }
	
	func determineProgressBar(count: Int) {
		var currLimit: CGFloat = 0.0 // calculated as a percentage
		
		// Since the character limit is different for each type of field (name, details, category) the switch case determines which limit is applied to the equation to calculate the currLimit (which is actually a percentage)

		switch EditTaskTextViewType.init(rawValue: inputTextView.tag) {
			case .Name:
				currLimit = CGFloat(count) / CGFloat(TaskCharacterLimits.taskNameMaximumCharacterLimit)
			case .Details:
				currLimit = CGFloat(count) / CGFloat(TaskCharacterLimits.taskDetailsMaximumCharacterLimit)
			case .Category:
				currLimit = CGFloat(count) / CGFloat(TaskCharacterLimits.taskCategoryMaximumCharacterLimit)
			case .none:
			()
		}
		
		DispatchQueue.main.async {
			self.progressBarContainer.updateColor(currLimit)
			self.progressBarContainer.updateProgressBar(currLimit)
		}
		
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
	
	func textViewDidBeginEditing(_ textView: UITextView) {
	}
	
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		let currLimit: Int = textView.text.count + (text.count - range.length)
		var characterLimit: Int = 0

		switch EditTaskTextViewType.init(rawValue: textView.tag) {
			case .Name:
				characterLimit = TaskCharacterLimits.taskNameMaximumCharacterLimit
			case .Details:
				characterLimit = TaskCharacterLimits.taskDetailsMaximumCharacterLimit
			case .Category:
				characterLimit = TaskCharacterLimits.taskCategoryMaximumCharacterLimit
			case .none:
			()
		}
		
		// produces physical haptic feedback for the user once the character limit is reached
		if (currLimit >= characterLimit) {
			ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
			return false
		}
		
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
		
		determineProgressBar(count: textView.text.count)
		
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
