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
	
    var completionClosure: (() -> ())?
    
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
        print("handle complete")
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [.transitionCrossDissolve]) {
            self.completionButton.isSelected = !self.completionButton.isSelected
            
//            self.completionButton.setAttributedTitle(NSMutableAttributedString(string: "Incomplete", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGreen, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b2).value)!]), for: .normal)
        } completion: { (_) in
            
        }
    }
    
//	override func updateConfiguration(using state: UICellConfigurationState) {
//
//		var contentConfig = TaskDetailCompletionContentConfiguration().updated(for: state)
//		contentConfig.name = state.completionItem?.name
//		contentConfig.completionState = state.completionItem?.isComplete
//		contentConfiguration = contentConfig
//	}
//
//    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
//        super.apply(layoutAttributes)
//        layoutIfNeeded()
//    }
}

// MARK: Config
struct TaskDetailCompletionContentConfiguration: UIContentConfiguration, Hashable {
	
	var name: String?
	var textColor: UIColor?
	var completionState: Bool?
	
	func makeContentView() -> UIView & UIContentView {
		TaskDetailCompletionContentView(configuration: self)
	}
	
	func updated(for state: UIConfigurationState) -> TaskDetailCompletionContentConfiguration {
		guard state is UICellConfigurationState else {
			return self
		}
		
		var updatedConfiguration = self
		updatedConfiguration.textColor = UIColor.complete
		return updatedConfiguration
	}
	
}

// MARK: Content View
class TaskDetailCompletionContentView: UIView, UIContentView {
	
	var configuration: UIContentConfiguration {
		get {
			  currentConfiguration
		  }
		  set {
			  // Make sure the given configuration is of type InputContentConfiguration
			  guard let newConfiguration = newValue as? TaskDetailCompletionContentConfiguration else {
				  return
			  }
			  
			  // Apply the new configuration to SFSymbolVerticalContentView
			  // also update currentConfiguration to newConfiguration
			  apply(configuration: newConfiguration)
		  }
		}
	
	private var currentConfiguration: TaskDetailCompletionContentConfiguration!
	
	private lazy var completionButton: UIButton = {
		let tf = UIButton()
        tf.layer.cornerRadius = 10.0
		tf.layer.borderWidth = 2
//        tf.setTitleColor(ThemeV2.TextColor.AddANote, for: .normal)
        tf.layer.borderColor = UIColor.complete.cgColor
		tf.translatesAutoresizingMaskIntoConstraints = false
		tf.addTarget(self, action: #selector(handleComplete), for: .touchDown)
		return tf
	}()
	
	private var constraintCheck: NSLayoutConstraint? = nil
	
    var completionButtonMethod: (() -> ())? = nil
    
	init(configuration: TaskDetailCompletionContentConfiguration) {
		super.init(frame: .zero)
//		layer.cornerRadius = 25
		clipsToBounds = true
		// Custom initializer implementation here.
		// Create the content view UI
		setupAllViews()
		
		// Apply the configuration (set data to UI elements / define custom content view appearance)
		apply(configuration: configuration)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupAllViews() {
		guard constraintCheck == nil else { return }
		addSubview(completionButton)
		
		constraintCheck = completionButton.topAnchor.constraint(equalTo: topAnchor)
		constraintCheck?.isActive = true
		completionButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        completionButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//		completionButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//		completionButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        completionButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
	}
	
	private func apply(configuration: TaskDetailCompletionContentConfiguration) {
		guard currentConfiguration != configuration else {
			return
		}
		
		// Replace current configuration with new configuration
		currentConfiguration = configuration
        
//		completionButton.setTitle(currentConfiguration.name, for: .normal)
		
        // Not working don't know how to animate view in cell
        UIView.animate(withDuration: 2.9) {
            if self.currentConfiguration.completionState ?? false {
//                self.completionButton.text = "Complete"
                self.completionButton.setTitleColor(ThemeV2.TextColor.AddANote.adjust(by: 50)!, for: .normal)
                self.completionButton.layer.borderColor = ThemeV2.TextColor.AddANote.adjust(by: 50)!.cgColor
            } else {
//                self.completionButton.text = "Incomplete"
//                self.completionButton.textColor = UIColor.systemPink
                self.completionButton.setTitle("Incomplete", for: .normal)
                self.completionButton.setTitleColor(UIColor.systemRed, for: .normal)
                self.completionButton.layer.borderColor = UIColor.systemRed.cgColor
            }
        }
	}
	
	func textViewDidChange(_ textView: UITextView) {
		currentConfiguration.name = textView.text ?? ""
	}
	
	@objc func handleComplete() {
        if let c = completionButtonMethod {
            c()
        }
        completionButtonMethod?()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view = completionButton.hitTest(completionButton.convert(point, from: self), with: event)
        if view == nil {
            view = super.hitTest(point, with: event)
        }

        return view
    }
}

