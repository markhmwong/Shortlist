//
//  BaseLabels.swift
//  Shortlist
//
//  Created by Mark Wong on 31/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

// MARK: Static label
class BaseStaticLabel: UILabel {
	
	init(frame: CGRect, fontSize: CGFloat) {
		super.init(frame: frame)
		font = ThemeV2.CellProperties.HeadingFont
		textColor = ThemeV2.TextColor.DefaultColor
		text = "Unknown"
		translatesAutoresizingMaskIntoConstraints = false
		numberOfLines = 0
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		font = ThemeV2.CellProperties.HeadingFont
		textColor = ThemeV2.TextColor.DefaultColor
		text = "Unknown"
		translatesAutoresizingMaskIntoConstraints = false
		numberOfLines = 0
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: Standard label
class BaseLabel: UILabel {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		font = UIFont.init(name: "HelveticaNeue", size: 20)?.with(weight: .bold)
		translatesAutoresizingMaskIntoConstraints = false
		numberOfLines = 0
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
