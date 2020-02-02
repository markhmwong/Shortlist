//
//  SelectCategoryInputView.swift
//  Shortlist
//
//  Created by Mark Wong on 24/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class SelectCategoryInputView: UIView {
	
	private var timer: Timer? = nil
	
	private var delegate: CategoryInputViewProtocol?
	
	private let padding: CGFloat = 7.0
		
	private var categoryExists: Bool = false
	
	private weak var persistentContainer: PersistentContainer?
	
	private let categoryNamePlaceholder: NSMutableAttributedString = NSMutableAttributedString(string: "A new category..", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b2).value)!])
	
	private lazy var categoryInputTextView: UITextView = {
		let view = UITextView()
		view.delegate = self
		view.backgroundColor = Theme.Cell.textFieldBackground
        view.keyboardAppearance = UIKeyboardAppearance.dark
		view.keyboardType = UIKeyboardType.default
		view.isEditable = true
		view.isUserInteractionEnabled = true
		view.isSelectable = true
		view.isScrollEnabled = false
		view.returnKeyType = UIReturnKeyType.done
        view.textColor = Theme.Font.DefaultColor
		view.translatesAutoresizingMaskIntoConstraints = false
		view.attributedText = categoryNamePlaceholder
		return view
	}()
	
	private lazy var postTaskButton: UIButton = {
		let button = UIButton()
		button.backgroundColor = .clear
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage(named:"Send.png"), for: .normal)
		button.addTarget(self, action: #selector(handlePostCategory), for: .touchUpInside)
		return button
	}()
	
	lazy var progressBar: ProgressBarContainer = {
		let view = ProgressBarContainer()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	init(delegate: CategoryInputViewProtocol, persistentContainer: PersistentContainer?) {
		self.delegate = delegate
		self.persistentContainer = persistentContainer
		super.init(frame: .zero)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupView() {
		addSubview(categoryInputTextView)
		addSubview(postTaskButton)
		addSubview(progressBar)
		
		categoryInputTextView.anchorView(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0))
		postTaskButton.anchorView(top: nil, bottom: nil, leading: nil, trailing: trailingAnchor, centerY: categoryInputTextView.centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: -padding), size: .zero)
		progressBar.anchorView(top: nil, bottom: nil, leading: nil, trailing: postTaskButton.leadingAnchor, centerY: categoryInputTextView.centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -5.0), size: .zero)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		sizeButtons()
	}
	
	private func sizeButtons() {
		let height = frame.height - frame.height * 0.45
		postTaskButton.heightAnchor.constraint(equalToConstant: height).isActive = true
		postTaskButton.widthAnchor.constraint(equalToConstant: height).isActive = true
		
		categoryInputTextView.trailingAnchor.constraint(equalTo: postTaskButton.leadingAnchor, constant: -padding).isActive = true
		
		progressBar.heightAnchor.constraint(equalToConstant: height).isActive = true
		progressBar.widthAnchor.constraint(equalToConstant: height).isActive = true
	}
	
	func focusField() {
		categoryInputTextView.becomeFirstResponder()
	}
	
	func updateField(_ category: String) {
		DispatchQueue.main.async {
			self.categoryInputTextView.text = category
		}
	}
	
	func reisgnInputText() {
		categoryInputTextView.resignFirstResponder()
	}
	
	func getCategoryFromInputField() -> String? {
		return categoryInputTextView.text
	}
	
	func resetInputField() {
		categoryInputTextView.attributedText = categoryNamePlaceholder
	}
	
	@objc
	func checkCategory() {
		guard let pc = persistentContainer else { return }
		let userInfo = timer?.userInfo as! [String : UITextView]
		categoryExists = pc.categoryExistsInBackLog(userInfo["categoryText"]?.text ?? "Uncategorized")

		// update view - reflects whether the category
		updateCategoryInputTextView(categoryExists ? UIColor.red.adjust(by: -30.0)! : UIColor.green.adjust(by: -30.0)!)
	}
	
	@objc
	func handlePostCategory() {
		guard let delegate = delegate else { return }
		//check if category exists
		if (!categoryExists) {
			delegate.addCategory()
			resetInputField()
			categoryInputTextView.resignFirstResponder()
		}
	}
	
	func liveCategoryCheck(_ textView: UITextView) {
		timer?.invalidate()
		timer = Timer.init(timeInterval: 0.5, target: self, selector: #selector(checkCategory), userInfo: ["categoryText" : textView], repeats: false)
		timer?.fire()
	}
	
	func updateCategoryInputTextView(_ color: UIColor) {
		DispatchQueue.main.async {
			self.categoryInputTextView.textColor = color
		}
	}
}

extension SelectCategoryInputView: UITextViewDelegate {
	
	// We're using this to dynamically adjust task name height when typing
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
			categoryInputTextView.sizeToFit()
            UIView.setAnimationsEnabled(true)
        }
		
		//a real time check if category exists
		liveCategoryCheck(textView)
		
		let currLimit: CGFloat = CGFloat(textView.text.count) / CGFloat(TaskCharacterLimits.taskCategoryMaximumCharacterLimit)
		progressBar.updateProgressBar(currLimit)
    }
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if (textView.text.count + (text.count - range.length) >= TaskCharacterLimits.taskCategoryMaximumCharacterLimit && textView.textColor == Theme.Font.DefaultColor) {
			ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
			return false
		}

		// Replaces placeholder text with user entered text
		if (textView.textColor == UIColor.lightGray) {
			textView.text = nil
			textView.textColor = Theme.Font.DefaultColor
		}
		return true
	}
}
