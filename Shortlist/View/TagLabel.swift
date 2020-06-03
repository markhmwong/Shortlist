//
//  TagLabel.swift
//  Shortlist
//
//  Created by Mark Wong on 3/6/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class TagLabel: UILabel {
	
	let padding = UIEdgeInsets(top: 2.0, left: 8.0, bottom: 2.0, right: 8.0)
	
	init(bgColor: UIColor) {
		super.init(frame: .zero)
		self.backgroundColor = bgColor
		self.translatesAutoresizingMaskIntoConstraints = false
		setupLabel()
	}
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		self.translatesAutoresizingMaskIntoConstraints = false
		setupLabel()
	}

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupLabel() {
		layer.cornerRadius = 8.0
		clipsToBounds = true
	}
	
	override var intrinsicContentSize: CGSize {
		let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
	}
	
}
