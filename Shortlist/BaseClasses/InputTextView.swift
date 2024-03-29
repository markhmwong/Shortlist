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

class InputTextView: UIView {

	private var inputState: TaskInputState = .closed
	
	private var timer: Timer? = nil
	
	private weak var delegate: CategoryInputViewProtocol?
	
	private let padding: CGFloat = 7.0
		
	private var categoryExists: Bool = false
	
	private weak var persistentContainer: PersistentContainer?
	
	private let categoryNamePlaceholder: NSMutableAttributedString = NSMutableAttributedString(string: "A new category..", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Placeholder, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b2).value)!])
	
	private lazy var textView: UITextView = {
		let view = UITextView()
		view.delegate = self
		view.backgroundColor = .clear
		view.isEditable = true
		view.keyboardAppearance = UIKeyboardAppearance.default
		view.keyboardType = UIKeyboardType.default
		view.returnKeyType = UIReturnKeyType.done
		view.font = ThemeV2.CellProperties.Title3Font
		view.textColor = ThemeV2.TextColor.DefaultColor
		view.translatesAutoresizingMaskIntoConstraints = false
//		view.placeholder = "Family, Work, Home, Sport..."
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
//		categoryInputTextView.addBottomBorder()
		sizeButtons()
	}
	
	private func setupView() {
		addSubview(textView)
		addSubview(progressBar)
		
		textView.anchorView(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0))

		progressBar.anchorView(top: nil, bottom: nil, leading: textView.trailingAnchor, trailing: nil, centerY: textView.centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -5.0), size: .zero)
		
		// setup depending on textfield type
		switch textFieldType {
			case .name:
				textView.textAlignment = .center
			case .category:
				textView.textAlignment = .center
		}
		
		maxCharacterLimit = textFieldType.maxCharacterLimit
		minCharacterLimit = textFieldType.minCharacterLimit
	}

	
	private func sizeButtons() {
		let height = frame.height - frame.height * 0.45
		
		progressBar.heightAnchor.constraint(equalToConstant: height).isActive = true
		progressBar.widthAnchor.constraint(equalToConstant: height).isActive = true
	}
	
	func focusField() {
		textView.becomeFirstResponder()
	}
	
	func updateField(_ category: String) {
		DispatchQueue.main.async {
			self.textView.text = category
		}
	}
	
	func reisgnInputText() {
		textView.resignFirstResponder()
	}
	
	func getCategoryFromInputField() -> String? {
		return textView.text
	}
	
	func resetInputField() {
		textView.attributedText = categoryNamePlaceholder
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
			textView.resignFirstResponder()
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
			self.textView.textColor = color
		}
	}
}

extension InputTextView: UITextViewDelegate {


	// We're using this to dynamically adjust task name height when typing
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
			textView.sizeToFit()
            UIView.setAnimationsEnabled(true)
        }

		//a real time check if category exists
		liveCategoryCheck(textView)

		let currLimit: CGFloat = CGFloat(textView.text.count) / CGFloat(TaskCharacterLimits.taskCategoryMaximumCharacterLimit)
		progressBar.updateProgressBar(currLimit)
		progressBar.updateColor(currLimit)
    }
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

		if (text == "\n" && text == categoryNamePlaceholder.string) {
			ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
			return false
		}

		if (text == "\n" && text != categoryNamePlaceholder.string) {
			handlePostCategory()
			textView.resignFirstResponder()
		}

		if (textView.text.count + (text.count - range.length) >= TaskCharacterLimits.taskCategoryMaximumCharacterLimit) {
			ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
			return false
		}

		// Replaces placeholder text with user entered text
		if (inputState == .closed) {
			inputState = .writing
			textView.clearTextOnFirstInput(Theme.Font.DefaultColor)
		}

		return true
	}
}

