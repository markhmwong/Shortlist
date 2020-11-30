//
//  SelectCategoryInputView.swift
//  Shortlist
//
//  Created by Mark Wong on 24/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

/*
	Mainly used for task creation
	Type type defines the character limit

*/
enum TextType {
	case name
	case category
	
	var maxCharacterLimit: Int {
		switch self {
			case .category:
				return TaskCharacterLimits.taskCategoryMaximumCharacterLimit
			case .name:
				return TaskCharacterLimits.taskNameMaximumCharacterLimit
		}
	}
	
	var minCharacterLimit: Int {
		switch self {
			case .category:
				return TaskCharacterLimits.taskCategoryMinimumCharacterLimit
			case .name:
				return TaskCharacterLimits.taskNameMinimumCharacterLimit
		}
	}
}

class SelectCategoryInputView: UIView {

	private var inputState: TaskInputState = .closed
	
	private var timer: Timer? = nil
	
	private weak var delegate: CategoryInputViewProtocol?
	
	private let padding: CGFloat = 7.0
		
	private var categoryExists: Bool = false
	
	private weak var persistentContainer: PersistentContainer?
	
	private let categoryNamePlaceholder: NSMutableAttributedString = NSMutableAttributedString(string: "A new category..", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Placeholder, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b2).value)!])
	
	private lazy var categoryInputTextView: UITextField = {
		let view = UITextField()
		view.delegate = self
		view.backgroundColor = .clear
        view.keyboardAppearance = UIKeyboardAppearance.default
		view.keyboardType = UIKeyboardType.default
		view.returnKeyType = UIReturnKeyType.done
		view.font = ThemeV2.CellProperties.Title3Font
		view.textColor = ThemeV2.TextColor.DefaultColor
		view.translatesAutoresizingMaskIntoConstraints = false
		view.placeholder = "Family, Work, Home, Sport..."
		view.becomeFirstResponder()
		return view
	}()
	
	var textFieldType: TextType

	var maxCharacterLimit: Int = 50
	
	var minCharacterLimit: Int = 3
	
//	private lazy var postTaskButton: UIButton = {
//		let button = UIButton()
//		button.backgroundColor = .clear
//		button.translatesAutoresizingMaskIntoConstraints = false
//		let image = UIImage(named:"Send.png")?.withTintColor(Theme.Font.DefaultColor, renderingMode: UIImage.RenderingMode.alwaysTemplate)
//		button.setImage(image, for: .normal)
//		button.addTarget(self, action: #selector(handlePostCategory), for: .touchUpInside)
//		return button
//	}()
	
	lazy var progressBar: ProgressBarContainer = {
		let view = ProgressBarContainer()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	init(type: TextType, delegate: CategoryInputViewProtocol, persistentContainer: PersistentContainer?) {
		self.delegate = delegate
		self.textFieldType = type
		self.persistentContainer = persistentContainer
		super.init(frame: .zero)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		categoryInputTextView.addBottomBorder()
		sizeButtons()
	}
	
	private func setupView() {
		addSubview(categoryInputTextView)
//		addSubview(postTaskButton)
		addSubview(progressBar)
		
		categoryInputTextView.anchorView(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0))
//		postTaskButton.anchorView(top: nil, bottom: nil, leading: nil, trailing: trailingAnchor, centerY: categoryInputTextView.centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: -padding), size: .zero)
		progressBar.anchorView(top: nil, bottom: nil, leading: categoryInputTextView.trailingAnchor, trailing: nil, centerY: categoryInputTextView.centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 0.0), size: .zero)
		
		// setup depending on textfield type
		switch textFieldType {
			case .name:
				categoryInputTextView.textAlignment = .center
				categoryInputTextView.placeholder = "Let's go!"
			case .category:
				categoryInputTextView.placeholder = "Family, Work, Home, Sport"
		}
		
		print(textFieldType.maxCharacterLimit)
		maxCharacterLimit = textFieldType.maxCharacterLimit
		minCharacterLimit = textFieldType.minCharacterLimit
	}

	
	private func sizeButtons() {
		let height = frame.height - frame.height * 0.45
//		postTaskButton.heightAnchor.constraint(equalToConstant: height).isActive = true
//		postTaskButton.widthAnchor.constraint(equalToConstant: height).isActive = true
		
//		categoryInputTextView.trailingAnchor.constraint(equalTo: .leadingAnchor, constant: -padding).isActive = true
		
//		progressBar.topAnchor
		
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
	
	@objc func checkCategory() {
		guard let pc = persistentContainer else { return }
		let userInfo = timer?.userInfo as! [String : UITextField] //UITextView
		categoryExists = pc.categoryExistsInBackLog(userInfo["categoryText"]?.text ?? "Uncategorized")

		// update view - reflects whether the category
		updateCategoryInputTextView(categoryExists ? UIColor.systemOrange.adjust(by: 10.0)! : UIColor.systemBlue.adjust(by: -20.0)!)
	}
	
	@objc func handlePostCategory() {
		inputState = .closed
		guard let delegate = delegate else {
			shutDownTimer()
			return
		}
		shutDownTimer() // for category check
		//check if category exists
		if (!categoryExists) {
			delegate.addCategory()
			resetInputField()
			categoryInputTextView.resignFirstResponder()
		}
	}
	
	func shutDownTimer() {
		timer?.invalidate()
		timer = nil
	}
	
	/*
		liveCategoryCheck
		
		A dynamic check. Runs whenever this function is called or in this case is called when the user types. Overlapping timers may be an issue but since categories are relatively short, I don't believe this will be an issue.
	
	*/
	func liveCategoryCheck(_ textView: UITextView) {
		timer?.invalidate()
		timer = Timer.init(timeInterval: 0.7, target: self, selector: #selector(checkCategory), userInfo: ["categoryText" : textView], repeats: false)
		timer?.fire()
	}
	
	func liveCategoryCheck(_ textView: UITextField) {
		timer?.invalidate()
		timer = Timer.init(timeInterval: 0.7, target: self, selector: #selector(checkCategory), userInfo: ["categoryText" : textView], repeats: false)
		timer?.fire()
	}
	
	func updateCategoryInputTextView(_ color: UIColor) {
		DispatchQueue.main.async {
			self.categoryInputTextView.textColor = color
		}
	}
}

extension SelectCategoryInputView: UITextFieldDelegate {
	private func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		return true
	}

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//		let size = textField.bounds.size
//		let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
//		if size.height != newSize.height {
//			UIView.setAnimationsEnabled(false)
//			categoryInputTextView.sizeToFit()
//			UIView.setAnimationsEnabled(true)
//		}
		
		//a real time check if category exists
		liveCategoryCheck(textField)
		
		// detect backspace. not having this "breaks" the textfield
		if let char = string.cString(using: String.Encoding.utf8) {
			let isBackSpace = strcmp(char, "\\b")
			if (isBackSpace == -92) {
				return true
			}
		}
		
		let currLimit: CGFloat = CGFloat(textField.text?.count ?? 1) / CGFloat(maxCharacterLimit)
		progressBar.updateProgressBar(currLimit)
		progressBar.updateColor(currLimit)
		
		if (string == "\n" && string == categoryNamePlaceholder.string) {
			ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
			return false
		}
		
		if (string == "\n" && string != categoryNamePlaceholder.string) {
			handlePostCategory()
			textField.resignFirstResponder()
		}
		
		if (textField.text?.count ?? 0 + (string.count - range.length) >= maxCharacterLimit) {
			ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
			return false
		}

		// Replaces placeholder text with user entered text
		if (inputState == .closed) {
			inputState = .writing
			textField.clearTextOnFirstInput(Theme.Font.DefaultColor)
		}
		return true
	}

	// We're using this to dynamically adjust task name height when typing
//    func textViewDidChange(_ textView: UITextView) {
//        let size = textView.bounds.size
//        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
//        if size.height != newSize.height {
//            UIView.setAnimationsEnabled(false)
//			categoryInputTextView.sizeToFit()
//            UIView.setAnimationsEnabled(true)
//        }
//
//		//a real time check if category exists
//		liveCategoryCheck(textView)
//
//		let currLimit: CGFloat = CGFloat(textView.text.count) / CGFloat(TaskCharacterLimits.taskCategoryMaximumCharacterLimit)
//		progressBar.updateProgressBar(currLimit)
//		progressBar.updateColor(currLimit)
//    }
	
//	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//		if (text == "\n" && text == categoryNamePlaceholder.string) {
//			ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
//			return false
//		}
//
//		if (text == "\n" && text != categoryNamePlaceholder.string) {
//			handlePostCategory()
//			textView.resignFirstResponder()
//		}
//
//		if (textView.text.count + (text.count - range.length) >= TaskCharacterLimits.taskCategoryMaximumCharacterLimit) {
//			ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
//			return false
//		}
//
//		// Replaces placeholder text with user entered text
//		if (inputState == .closed) {
//			inputState = .writing
//			textView.clearTextOnFirstInput(Theme.Font.DefaultColor)
//		}
//
//		return true
//	}
}
