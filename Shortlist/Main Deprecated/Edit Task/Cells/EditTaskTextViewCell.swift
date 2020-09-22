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

	private var categoryExists: Bool = false

	private var timer: Timer? = nil
	
	typealias TaskName = String
	
	//updates string in view model
	var updateTaskString: ((TaskName, IndexPath) -> ())? = nil
	
	var updateCategory: ((TaskName, Bool) -> ())? = nil
	
    weak var persistentContainer: PersistentContainer?

	private var details: String?
	
	var size: CGFloat = Theme.Font.FontSize.Standard(.b0).value
	
	lazy var inputTextView: UITextView = {
        let view = UITextView()
        view.delegate = self
		view.backgroundColor = Theme.GeneralView.textFieldBackground
        view.keyboardType = UIKeyboardType.default
        view.keyboardAppearance = UIKeyboardAppearance.default
		view.textColor = Theme.Font.DefaultColor
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
	
	lazy var textLimitContainer: ProgressBarContainer = {
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
	
	@objc func handleDone() {
		inputTextView.resignFirstResponder()
	}
	
	override func setupCellLayout() {
		super.setupCellLayout()
		backgroundColor = Theme.GeneralView.background
		contentView.addSubview(inputTextView)
		contentView.addSubview(textLimitContainer)

		//constraint fix - https://stackoverflow.com/questions/58530406/unable-to-simultaneously-satisfy-constraints-when-uitoolbarcontentview-is-presen
		let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 44.0)))
		toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))]
		toolbar.translatesAutoresizingMaskIntoConstraints = false
		toolbar.barStyle = .default
		inputTextView.inputAccessoryView = toolbar
		
		textLimitContainer.updateColor(0.0)
		textLimitContainer.updateProgressBar(0.0)
	}
	
	override func layoutIfNeeded() {
		super.layoutIfNeeded()
		inputTextView.anchorView(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: contentView.layoutMarginsGuide.leadingAnchor, trailing: textLimitContainer.leadingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: -5.0, right: -8.0), size: CGSize(width: 0, height: 0.0))
		textLimitContainer.anchorView(top: inputTextView.topAnchor, bottom: nil, leading: nil, trailing: contentView.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -5.0), size: CGSize(width: 18.0, height: 18.0))
	}
	
	func configure(with text: String?) {
		if let text = text {
			let nameAttributedStr = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: size)!])
            inputTextView.attributedText = nameAttributedStr
		} else {
			let nameAttributedStr = NSMutableAttributedString(string: "unknown", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: size)!])
            inputTextView.attributedText = nameAttributedStr
		}
    }
	
	func updateTask(taskNameString: String) {
		inputTextView.attributedText = NSMutableAttributedString().primaryCellText(text: taskNameString)
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
			self.textLimitContainer.updateColor(currLimit)
			self.textLimitContainer.updateProgressBar(currLimit)
		}
		
	}
	
	func shutDownTimer() {
		timer?.invalidate()
		timer = nil
	}
	
	func liveCategoryCheck(_ textView: UITextView) {
		timer?.invalidate()
		timer = Timer.init(timeInterval: 0.7, target: self, selector: #selector(checkCategory), userInfo: ["categoryText" : textView], repeats: false)
		timer?.fire()
	}
	
	func updateCategoryInputTextView(_ color: UIColor) {
		DispatchQueue.main.async {
			self.inputTextView.textColor = color
		}
	}
	
	@objc func checkCategory() {
		guard let pc = persistentContainer else { return }
		let userInfo = timer?.userInfo as! [String : UITextView]
		categoryExists = pc.categoryExistsInBackLog(userInfo["categoryText"]?.text ?? "Uncategorized")

		// update view - reflects whether the category
		updateCategoryInputTextView(categoryExists ? UIColor.blue.adjust(by: 10.0)! : UIColor.green.adjust(by: 30.0)!)
		updateCategory?(userInfo["categoryText"]?.text ?? "", categoryExists)

		shutDownTimer()
		
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
		liveCategoryCheck(textView)
		
        
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
