//
//  BaseLabels.swift
//  Shortlist
//
//  Created by Mark Wong on 31/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class BaseStaticLabel: UILabel {
	
	init(frame: CGRect, fontSize: CGFloat) {
		super.init(frame: frame)
		font = UIFont.init(name: "HelveticaNeue-Bold", size: fontSize)
		textColor = UIColor.black.lighter(by: 50.0)!
		text = "Unknown"
		translatesAutoresizingMaskIntoConstraints = false
		numberOfLines = 0
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		font = UIFont.init(name: "HelveticaNeue-Bold", size: 13)
		textColor = UIColor.black.lighter(by: 50.0)!
		text = "Unknown"
		translatesAutoresizingMaskIntoConstraints = false
		numberOfLines = 0
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
