//
//  TaskDetailCell+Completion.swift
//  Shortlist
//
//  Created by Mark Wong on 17/2/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit

extension UICellConfigurationState {
	var completionItem: CompletionItem? {
		set { self[.completionItem] = newValue }
		get { return self[.completionItem] as? CompletionItem }
	}
}

fileprivate extension UIConfigurationStateCustomKey {
	static let completionItem = UIConfigurationStateCustomKey("com.whizbang.shortlist.cell.completion")
}

//https://gist.github.com/T-Pham/82e8f4fe9676cef4923aa05fff27f6cb
extension UIControl.State {
    public static let incomplete: UIControl.State = UIControl.State.init(rawValue: 1 << 16)
}

class TaskDetailCompletionCell: BaseCell<CompletionItem> {
	
    var completionClosure: ((Bool) -> ())?
    
    private lazy var completionButton: PaddedButton = {
        let tf = PaddedButton(xPadding: 20, yPadding: 5)
        tf.backgroundColor = Theme.Font.DefaultColor
        tf.layer.cornerRadius = 10.0
        tf.layer.borderWidth = 0
        tf.setAttributedTitle(NSMutableAttributedString(string: "Complete", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor.adjust(by: -70)!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b2).value)!]), for: .normal)
        tf.setAttributedTitle(NSMutableAttributedString(string: "Incomplete", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor.adjust(by: -70)!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b2).value)!]), for: .selected)
        tf.layer.borderColor = UIColor.complete.cgColor
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(handleComplete), for: .touchDown)
        return tf
    }()
    
	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.completionItem = self.item
		return state
	}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewAdditionalViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	private var viewConstraintCheck: NSLayoutConstraint? = nil
	
    private func setupViewAdditionalViews() {
        let fade: CATransition = CATransition()
        fade.duration = 1.0
        fade.type = .fade

        completionButton.layer.add(fade, forKey: "fade")
        contentView.addSubview(completionButton)
        completionButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        completionButton.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
    }
    
    @objc func handleComplete() {
        self.completionButton.isSelected = !self.completionButton.isSelected
        self.completionClosure?(self.completionButton.isSelected)
    }
    
	override func updateConfiguration(using state: UICellConfigurationState) {
        completionButton.isSelected = state.completionItem!.isComplete
	}
}

