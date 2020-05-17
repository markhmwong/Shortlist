//
//  NSMutableAttributedString.swift
//  Shortlist
//
//  Created by Mark Wong on 16/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
	
	func primarySectionText(text: String) -> NSMutableAttributedString {
		return NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.h3).value)!])
	}
	
	func primaryCellText(text: String) -> NSMutableAttributedString {
		return NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b2).value)!])
	}
	
}
