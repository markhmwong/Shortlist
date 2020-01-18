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
    
    enum DayColor {
        case Standard
        case Custom(Date)
        
        var value: UIColor {
            switch self {
            case .Standard:
                switch Calendar.current.todayToInt() {
                case DayOfWeek.Sunday.rawValue: //Sunday
                    return UIColor(red:1.00, green:0.40, blue:0.25, alpha:1.0)
                case DayOfWeek.Monday.rawValue: //Monday
                    return UIColor(red:0.44, green:0.89, blue:0.47, alpha:1.0)
                case DayOfWeek.Tuesday.rawValue: //Tuesday
                    return UIColor(red:0.26, green:0.91, blue:0.79, alpha:1.0)
                case DayOfWeek.Wednesday.rawValue:
                    return UIColor(red:0.88, green:0.31, blue:0.38, alpha:1.0)
                case DayOfWeek.Thursday.rawValue:
                    return UIColor(red:0.60, green:0.36, blue:0.79, alpha:1.0)
                case DayOfWeek.Friday.rawValue: // Friday
                    return UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
                case DayOfWeek.Saturday.rawValue: // Saturday
                    return UIColor(red:1.00, green:0.40, blue:0.25, alpha:1.0)
                default:
                    return UIColor.blue
                }
            default:
                return UIColor.black
            }
        }
    }
	
    lazy var donateButton: UIButton = {
        let button = UIButton()
        return button
    }()
    	
    lazy var reviewTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
		var str = NSMutableAttributedString(string: "Review", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.TitleBold, size: Theme.Font.FontSize.Standard(.h3).value)!])
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
		label.attributedText = NSMutableAttributedString(string: "Hidden when you complete all tasks", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color.adjust(by: -40.0)!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b4).value)!])
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
        label.attributedText = NSAttributedString(string: "Completed", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b2).value)!])
        return label
    }()
    
    lazy var completedTasks: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "0 / 5", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.h3).value)!])
        return label
    }()
	
    lazy var tipJarTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Tip for incompleted tasks", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.h3).value)!])
        return label
    }()
    
    lazy var dateBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.03, green:0.03, blue:0.03, alpha:1.0)//DayColor.Standard.value
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var feelGoodMessage: UILabel = {
        let label = UILabel()
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
    
    private func setupView() {
        guard let _viewModel = viewModel else { return }
        translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = UIColor(red:0.02, green:0.12, blue:0.20, alpha:1.0)
		
        let totalTasks = _viewModel.dayEntity?.totalTasks
        let totalCompleted = _viewModel.dayEntity?.totalCompleted
//        completedTasks.attributedText = NSAttributedString(string: "\(totalCompleted ?? 0) / \(totalTasks ?? 5)", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.h3).value)!])
		
		addSubview(reviewTitle)
		let estimatedFrameInstructionTitle = NSString(string: reviewTitle.text!).boundingRect(with: CGSize(width: bounds.width, height: 1000), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color.darker(by: 50.0)!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b3).value)!], context: nil)
		
//		if (totalTasks != totalCompleted) {
		if (true) {
			addSubview(coffeeTip)
			addSubview(generousTip)
			addSubview(amazingTip)
			addSubview(tipDisclaimer)
			
			_viewModel.buttonArr.append(coffeeTip)
			_viewModel.buttonArr.append(generousTip)
			_viewModel.buttonArr.append(amazingTip)
			
			coffeeTip.anchorView(top: generousTip.topAnchor, bottom: nil, leading: nil, trailing: generousTip.leadingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -10.0), size: CGSize(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.06))
			generousTip.anchorView(top: reviewTitle.bottomAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.06))
			amazingTip.anchorView(top: generousTip.topAnchor, bottom: nil, leading: generousTip.trailingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0), size: CGSize(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.06))
			tipDisclaimer.anchorView(top: generousTip.bottomAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: 15.0, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
			reviewTitle.anchorView(top: safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: estimatedFrameInstructionTitle.height, left: 10.0, bottom: 0.0, right: 10.0), size: .zero)
		} else {

			heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.23).isActive = true

			reviewTitle.anchorView(top: safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: estimatedFrameInstructionTitle.height, left: 10.0, bottom: 0.0, right: 10.0), size: .zero)
		}
		
//		addSubview(completedTasksTitle)
//        addSubview(completedTasks)
        
//        completedTasksTitle.anchorView(top: reviewTitle.bottomAnchor, bottom: nil, leading: reviewTitle.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 40.0, left: 0.0, bottom: 0.0, right: -10.0), size: CGSize(width: UIScreen.main.bounds.width, height: estimatedFrameInstructionTitle.height))
//        completedTasks.anchorView(top: completedTasksTitle.bottomAnchor, bottom: nil, leading: reviewTitle.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 5.0, left: 0.0, bottom: 0.0, right: -10.0), size: CGSize(width: UIScreen.main.bounds.width, height: 0.0))
    }
    
    func heightRatioForHeader() -> CGFloat {
        switch UIDevice.current.screenType.rawValue {
        case UIDevice.ScreenType.iPhones_6Plus_6sPlus_7Plus_8Plus.rawValue, UIDevice.ScreenType.iPhones_6_6s_7_8.rawValue:
            return 4.0
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue:
            return 4.0
        case UIDevice.ScreenType.iPhoneXSMax.rawValue, UIDevice.ScreenType.iPhoneX_iPhoneXS.rawValue, UIDevice.ScreenType.iPhoneXR.rawValue:
            return 4.0
        default:
            return 4.0
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
