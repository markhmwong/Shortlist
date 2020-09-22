//
//  UITextView+Extension.swift
//  Shortlist
//
//  Created by Mark Wong on 24/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

extension UITextView {
	
	func clearTextOnFirstInput(_ color: UIColor) {
		self.text = nil
		self.textColor = color
	}
}
