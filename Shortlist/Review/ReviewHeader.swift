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
		var str = NSMutableAttributedString(string: "Review", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b3).value)!])
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
		label.attributedText = NSMutableAttributedString(string: "Hidden when you complete all tasks", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor.adjust(by: -40.0)!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b4).value)!])
		label.translatesAutoresizingMaskIntoConstraints = false
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
	
	override func layoutIfNeeded() {
		super.layoutIfNeeded()
        guard let _viewModel = viewModel else { return }

		let totalTasks = _viewModel.dayEntity?.totalTasks
        let totalCompleted = _viewModel.dayEntity?.totalCompleted
		
		//		if (totalTasks != totalCompleted) {
		if (true) {
			let buttonHeight: CGFloat = UIScreen.main.bounds.height * 0.05
			
			coffeeTip.anchorView(top: generousTip.topAnchor, bottom: nil, leading: nil, trailing: generousTip.leadingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -10.0), size: CGSize(width: UIScreen.main.bounds.width * 0.30, height: buttonHeight))
			generousTip.anchorView(top: accoladeLabel.bottomAnchor, bottom: tipDisclaimer.topAnchor, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: -10.0, right: 0.0), size: CGSize(width: UIScreen.main.bounds.width * 0.30, height: buttonHeight))
			amazingTip.anchorView(top: generousTip.topAnchor, bottom: nil, leading: generousTip.trailingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0), size: CGSize(width: UIScreen.main.bounds.width * 0.25, height: buttonHeight))
			tipDisclaimer.anchorView(top: generousTip.bottomAnchor, bottom: bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -5.0, right: 0.0), size: .zero)
		}
	}
    
    private func setupView() {
        guard let _viewModel = viewModel else { return }
        translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = Theme.GeneralView.headerBackground
		addSubview(reviewTitle)
		addSubview(accoladeLabel)
		
		reviewTitle.anchorView(top: safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0), size: .zero)

		accoladeLabel.anchorView(top: reviewTitle.bottomAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: reviewTitle.centerXAnchor, padding: .zero, size: .zero)
        let totalTasks = _viewModel.dayEntity?.totalTasks
        let totalCompleted = _viewModel.dayEntity?.totalCompleted
//        completedTasks.attributedText = NSAttributedString(string: "\(totalCompleted ?? 0) / \(totalTasks ?? 5)", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.h3).value)!])
		
		

		
//		if (totalTasks != totalCompleted) {
		if (true) {
			addSubview(coffeeTip)
			addSubview(generousTip)
			addSubview(amazingTip)
			addSubview(tipDisclaimer)
			
			_viewModel.buttonArr.append(coffeeTip)
			_viewModel.buttonArr.append(generousTip)
			_viewModel.buttonArr.append(amazingTip)
			

		} else {

//			heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.23).isActive = true
//
//			reviewTitle.anchorView(top: safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: estimatedFrameInstructionTitle.height, left: 10.0, bottom: 0.0, right: 10.0), size: .zero)
		}
		
//		addSubview(completedTasksTitle)
//        addSubview(completedTasks)
        
//        completedTasksTitle.anchorView(top: reviewTitle.bottomAnchor, bottom: nil, leading: reviewTitle.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 40.0, left: 0.0, bottom: 0.0, right: -10.0), size: CGSize(width: UIScreen.main.bounds.width, height: estimatedFrameInstructionTitle.height))
//        completedTasks.anchorView(top: completedTasksTitle.bottomAnchor, bottom: nil, leading: reviewTitle.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 5.0, left: 0.0, bottom: 0.0, right: -10.0), size: CGSize(width: UIScreen.main.bounds.width, height: 0.0))
    }
	
	func updateAccoladeLabel(_ accoladeStr: String) {
		DispatchQueue.main.async {
			self.accoladeLabel.attributedText = NSMutableAttributedString(string: accoladeStr, attributes: [NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: 14.0)!, NSAttributedString.Key.foregroundColor: Theme.Font.DefaultColor])
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
