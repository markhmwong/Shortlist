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
        var attributedStr: NSMutableAttributedString = NSMutableAttributedString(string: "\(str) ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.strokeWidth : -3.0, NSAttributedString.Key.strokeColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.h1).value)!])
        attributedStr.append(NSAttributedString(string: "\(monthString)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.h1).value)!]))
        label.attributedText = attributedStr
        return label
    }()
    
    lazy var reviewTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Yesterday's Review", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b1).value)!])
        return label
    }()
    
    lazy var instructionTitle: UITextView = {
        let label = UITextView()
        label.textContainerInset = .zero
        label.textContainer.lineFragmentPadding = 0
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.isScrollEnabled = false
        label.isEditable = false
        label.isSelectable = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Select tasks you'd like to carry over from yesterday.", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color.darker(by: 50.0)!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b3).value)!])
        return label
    }()
    
    lazy var dateBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = DayColor.Standard.value
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
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
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
        heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / heightRatioForHeader()).isActive = true
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        addSubview(dateBackgroundView)
        dateBackgroundView.addSubview(dateTitle)
        
        let estimatedFrame = NSString(string: dateTitle.text!).boundingRect(with: CGSize(width: bounds.width, height: 1000), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.h0).value)!], context: nil)
        
        dateBackgroundView.anchorView(top: safeAreaLayoutGuide.topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: 0.0, height: estimatedFrame.height))
        dateTitle.anchorView(top: nil, bottom: nil, leading: leadingAnchor, trailing: nil, centerY: dateBackgroundView.centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0), size: .zero)

        if (reviewLabelState) {
            addSubview(reviewTitle)
            addSubview(instructionTitle)
            
            let estimatedFrameInstructionTitle = NSString(string: instructionTitle.text!).boundingRect(with: CGSize(width: bounds.width, height: 1000), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color.darker(by: 50.0)!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b3).value)!], context: nil)
            
            reviewTitle.anchorView(top: dateTitle.bottomAnchor, bottom: nil, leading: dateTitle.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: estimatedFrameInstructionTitle.height, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
            instructionTitle.anchorView(top: reviewTitle.bottomAnchor, bottom: nil, leading: reviewTitle.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: UIScreen.main.bounds.width, height: estimatedFrameInstructionTitle.height))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
