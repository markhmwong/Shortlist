//
//  CustomLabel.swift
//  Five
//
//  Created by Mark Wong on 17/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    let topInset: CGFloat = 5.0
    let bottomInset: CGFloat = 5.0
    let leftInset: CGFloat = 7.0
    let rightInset: CGFloat = 7.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
