//
//  TaskListHeader.swift
//  Five
//
//  Created by Mark Wong on 20/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class TaskListHeader: UIView {
    
    lazy var dateTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        let currentDate = Date()
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "MMMM"
        let monthString = nameFormatter.string(from: currentDate)
        let str = date!.toString(format: "dd")
        
        var attributedStr: NSMutableAttributedString = NSMutableAttributedString(string: "\(str) ", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.h0).value)!])
        
        attributedStr.append(NSAttributedString(string: "\(monthString)", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.h1).value)!]))
        
        label.attributedText = attributedStr
        label.textColor = .white
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Select tasks you'd like to carry over from yesterday.", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color.darker(by: 50.0)!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b3).value)!])
        return label
    }()
    
    var date: Date? = nil
    
    var reviewLabelState: Bool = false
    
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
    
    convenience init(date: Date, reviewState: Bool) {
        self.init(frame: .zero)
        self.date = date
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

        addSubview(dateTitle)
        dateTitle.anchorView(top: safeAreaLayoutGuide.topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0), size: .zero)

        if (reviewLabelState) {
            addSubview(reviewTitle)
            addSubview(instructionTitle)
            reviewTitle.anchorView(top: dateTitle.bottomAnchor, bottom: nil, leading: dateTitle.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: .zero)
            instructionTitle.anchorView(top: reviewTitle.bottomAnchor, bottom: nil, leading: reviewTitle.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: UIScreen.main.bounds.width, height: 50.0))
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
