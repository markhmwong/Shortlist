//
//  ReviewHeader.swift
//  Shortlist
//
//  Created by Mark Wong on 17/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import StoreKit

// set out to do x tasks

class ReviewHeader: UIView {
    	
    lazy var reviewTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
		var str = NSMutableAttributedString(string: "Review", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b1).value)!])
        label.attributedText = str
        return label
    }()
	
    lazy var coffeeTip: StandardButton = {
        let button = StandardButton(title: "Short Tip N/A")
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(handleCoffeeTip), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var generousTip: StandardButton = {
        let button = StandardButton(title: "Tall Tip N/A")
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        
        button.addTarget(self, action: #selector(handleGenerousTip), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
	
	lazy var tipDisclaimer: UILabel = {
		let label = UILabel()
		label.attributedText = NSMutableAttributedString(string: "Consider this a nagging pop up when you don't complete the tasks you have set out to do. Show your support by reviewing on the App Store, emailing me feedback, or easily donating below.", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor.adjust(by: 0.0)!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b4).value)!])
		label.translatesAutoresizingMaskIntoConstraints = false
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.textAlignment = .center
		label.backgroundColor = .clear
		return label
	}()
    
    lazy var amazingTip: StandardButton = {
        let button = StandardButton(title: "Grande Tip N/A")
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        
        button.addTarget(self, action: #selector(handleAmazingTip), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var completedTasksTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Completed", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b2).value)!])
        return label
    }()
    
    lazy var completedTasks: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "0 / 5", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.h3).value)!])
        return label
    }()
	
    lazy var tipJarTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Tip for incompleted tasks", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.h3).value)!])
        return label
    }()
    
    lazy var dateBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.03, green:0.03, blue:0.03, alpha:1.0)//DayColor.Standard.value
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var accoladeLabel: UILabel = {
        let label = UILabel()
		label.attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.h2).value)!, NSAttributedString.Key.foregroundColor: Theme.Font.DefaultColor])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
	
	lazy var tipButtonContainer: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .clear
		return view
	}()
    
    var date: Date? = nil
    
    var viewModel: ReviewViewModel?
    
    weak var delegate: ReviewViewController? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(date: Date, viewModel: ReviewViewModel) {
        self.init(frame: .zero)
        self.date = date
        self.viewModel = viewModel
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
    private func setupView() {
        guard let _viewModel = viewModel else { return }
        translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = Theme.GeneralView.headerBackground
		addSubview(reviewTitle)
		addSubview(accoladeLabel)
		addSubview(completedTasksTitle)
        addSubview(completedTasks)
		
		reviewTitle.anchorView(top: safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: 20.0, left: 10.0, bottom: 0.0, right: 10.0), size: .zero)

		accoladeLabel.anchorView(top: reviewTitle.bottomAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: 20.0, left: 0.0, bottom: -20.0, right: 0.0), size: .zero)
		
		completedTasksTitle.anchorView(top: accoladeLabel.bottomAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: 15.0, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
		
		let totalCompleted = _viewModel.dayEntity?.dayToStats?.totalCompleted ?? 0
		updateCompletedTaskLabel("\(totalCompleted)")
		
		let totalTasks = _viewModel.dayEntity?.dayToStats?.totalTasks
		
		if (totalTasks != totalCompleted || totalTasks == 0) {
			completedTasks.anchorView(top: completedTasksTitle.bottomAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: reviewTitle.centerXAnchor, padding: UIEdgeInsets(top: 5.0, left: 0.0, bottom: -20.0, right: 0.0), size: CGSize(width: 0.0, height: 0.0))
			
			addSubview(tipButtonContainer)
			tipButtonContainer.addSubview(tipDisclaimer)

			tipDisclaimer.anchorView(top: tipButtonContainer.topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: -20.0), size: CGSize(width: 0.0, height: 0.0))

			tipButtonContainer.addSubview(coffeeTip)
			tipButtonContainer.addSubview(generousTip)
			tipButtonContainer.addSubview(amazingTip)
			
			_viewModel.buttonArr.append(coffeeTip)
			_viewModel.buttonArr.append(generousTip)
			_viewModel.buttonArr.append(amazingTip)
			
			let buttonHeight: CGFloat = UIScreen.main.bounds.height * 0.05
			let buttonWidth: CGFloat = UIScreen.main.bounds.width * 0.30

			tipButtonContainer.isHidden = false
			
			tipButtonContainer.anchorView(top: completedTasks.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .init(top: 0.0, left: 0.0, bottom: -10.0, right: 0.0), size: .zero)

			coffeeTip.anchorView(top: generousTip.topAnchor, bottom: tipButtonContainer.bottomAnchor, leading: nil, trailing: generousTip.leadingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -10.0), size: CGSize(width: buttonWidth, height: buttonHeight))

			generousTip.anchorView(top: tipDisclaimer.bottomAnchor, bottom: tipButtonContainer.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: tipButtonContainer.centerXAnchor, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: -10.0), size: CGSize(width: buttonWidth, height: buttonHeight))

			amazingTip.anchorView(top: generousTip.topAnchor, bottom: tipButtonContainer.bottomAnchor, leading: generousTip.trailingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0), size: CGSize(width: buttonWidth, height: buttonHeight))

		} else {
			completedTasks.anchorView(top: completedTasksTitle.bottomAnchor, bottom: bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: reviewTitle.centerXAnchor, padding: UIEdgeInsets(top: 5.0, left: 0.0, bottom: -20.0, right: 0.0), size: CGSize(width: 0.0, height: 0.0))
		}
    }
	
	func updateAccoladeLabel(_ accoladeStr: String) {
		DispatchQueue.main.async {
			self.accoladeLabel.attributedText = NSMutableAttributedString(string: accoladeStr, attributes: [NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.h3).value)!, NSAttributedString.Key.foregroundColor: Theme.Font.DefaultColor])
		}
	}
	
	func updateCompletedTaskLabel(_ numberStr: String) {
		guard let _viewModel = viewModel else { return }
		let totalTasks = _viewModel.dayEntity?.dayToStats?.totalTasks
		
		DispatchQueue.main.async {
			self.completedTasks.attributedText = NSAttributedString(string: "\(numberStr) / \(totalTasks ?? 5)", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.h3).value)!])
		}
	}
	
    @objc func handleCoffeeTip(_ button: StandardButton) {
        button.buyButtonHandler?(button.product!)
    }
    
    @objc func handleGenerousTip(_ button: StandardButton) {
        button.buyButtonHandler?(button.product!)
    }
    
    @objc func handleAmazingTip(_ button: StandardButton) {
        button.buyButtonHandler?(button.product!)
    }
}
