//
//  UITextField.swift
//  Shortlist
//
//  Created by Mark Wong on 16/11/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

extension UITextField {
	func addBottomBorder() {
		let bottomLine = CALayer()
		bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
		bottomLine.backgroundColor = UIColor.white.cgColor
		borderStyle = .none
		layer.addSublayer(bottomLine)
	}
}
