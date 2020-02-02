//
//  TaskListHeader.swift
//  Five
//
//  Created by Mark Wong on 20/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class TaskListHeader: UIView {
    
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
    
    lazy var dateTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let currentDate = Date()
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "MMMM"
        let monthString = nameFormatter.string(from: currentDate)
        let str = date!.toString(format: "dd")
        var attributedStr: NSMutableAttributedString = NSMutableAttributedString(string: "\(str) ", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.strokeWidth : -3.0, NSAttributedString.Key.strokeColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b1).value)!])
		attributedStr.append(NSAttributedString(string: "\(monthString)", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b1).value)!]))
        label.attributedText = attributedStr
        return label
    }()
    

    
	// find weather api that allows lots of requests
	// or use google firebase
//    lazy var weather: UITextView = {
//        let label = UITextView()
//        label.textContainerInset = .zero
//        label.textContainer.lineFragmentPadding = 0
//        label.textAlignment = .center
//        label.backgroundColor = .clear
//        label.isScrollEnabled = false
//        label.isEditable = false
//        label.isSelectable = false
//		label.backgroundColor = .clear
//        label.translatesAutoresizingMaskIntoConstraints = false
//		label.attributedText = NSAttributedString(string: "A sunny day ahead with a light breeze.", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.TitleRegular, size: Theme.Font.FontSize.Standard(.b4).value)!])
//        return label
//    }()
    
    lazy var dateBackgroundView: UIView = {
        let view = UIView()
		view.backgroundColor = .clear//DayColor.Standard.value
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var date: Date? = nil
    
    var reviewLabelState: Bool = false
    
    weak var delegate: ReviewViewController? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(date: Date) {
        self.init(frame: .zero)
        self.date = date

        setupView()
    }
    
    convenience init(date: Date, reviewState: Bool, delegate: ReviewViewController) {
        self.init(frame: .zero)
        self.date = date
        self.delegate = delegate
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        reviewLabelState = reviewState
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red:0.05, green:0.05, blue:0.05, alpha:1.0)
		
		heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.04).isActive = true
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        addSubview(dateBackgroundView)
        dateBackgroundView.addSubview(dateTitle)
        
        dateBackgroundView.anchorView(top: safeAreaLayoutGuide.topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -10.0, right: 0.0), size: CGSize(width: 0.0, height: UIScreen.main.bounds.height * 0.12))


//		addSubview(weather)
//		weather.anchorView(top: dateTitle.bottomAnchor, bottom: nil, leading: dateTitle.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: UIScreen.main.bounds.width, height: 0.0))

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
		dateTitle.anchorView(top: dateBackgroundView.topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, centerY: centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0), size: .zero)
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
}
