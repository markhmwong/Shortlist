//
//  TaskListHeader.swift
//  Five
//
//  Created by Mark Wong on 20/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class TaskListHeader: UIView {
    
    lazy var day: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let calendar = Calendar.current
        let str = calendar.component(.day, from: Date())
        label.attributedText = NSAttributedString(string: "\(str)", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Name, size: Theme.Font.FontSize.Standard(.h0).value)!])
        label.textColor = .white
        return label
    }()
    
    lazy var month: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let calendar = Calendar.current
        let str = calendar.component(.month, from: Date())
        label.attributedText = NSAttributedString(string: "\(str)", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Name, size: Theme.Font.FontSize.Standard(.h1).value)!])
        label.textColor = .white
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / heightRatioForHeader()).isActive = true
        
        
        addSubview(day)
        addSubview(month)
        
        day.anchorView(top: safeAreaLayoutGuide.topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        month.anchorView(top: day.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: .zero)
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
