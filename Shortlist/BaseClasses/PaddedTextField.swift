//
//  PaddedTextField.swift
//  Shortlist
//
//  Created by Mark Wong on 15/11/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class PaddedTextField: UITextField {

	let padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)

	override open func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}

	override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}
	
	override open func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		
		self.addBottomBorder()
	}
	
}
