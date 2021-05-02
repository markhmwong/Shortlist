//
//  PaddedLabel.swift
//  Shortlist
//
//  Created by Mark Wong on 19/2/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit

class PaddedLabel: UILabel {
	
//	let padding = UIEdgeInsets(top: 80.0, left: 8.0, bottom: 80.0, right: 8.0)
	
	var padding: UIEdgeInsets
	
	init(xPadding: CGFloat = 0.0, yPadding: CGFloat = 0.0) {
		self.padding = UIEdgeInsets(top: yPadding, left: xPadding, bottom: yPadding, right: xPadding)
		super.init(frame: .zero)
		self.setupLabel()
	}
	
//	override init(frame: CGRect) {
//		super.init(frame: .zero)
//		self.setupLabel()
//	}

	override func drawText(in rect: CGRect) {
		super.drawText(in: rect.inset(by: padding))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupLabel() {
		self.translatesAutoresizingMaskIntoConstraints = false
		self.font = UIFont.preferredFont(forTextStyle: .body)
		self.numberOfLines = 0
		self.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
		self.layer.cornerRadius = 8.0
		self.clipsToBounds = true
	}
	
	func updateColor(newColor: UIColor) {
		self.backgroundColor = newColor
		self.textColor = self.backgroundColor?.darker(by: 70.0)
	}

	override var intrinsicContentSize: CGSize {
		let superContentSize = super.intrinsicContentSize
		let width = superContentSize.width + padding.left + padding.right
		let heigth = superContentSize.height + padding.top + padding.bottom
		return CGSize(width: width, height: heigth)
	}
}

class PaddedButton: UIButton {
    
//    let padding = UIEdgeInsets(top: 80.0, left: 8.0, bottom: 80.0, right: 8.0)
    
    var padding: UIEdgeInsets
    
    init(xPadding: CGFloat = 0.0, yPadding: CGFloat = 0.0) {
        self.padding = UIEdgeInsets(top: yPadding, left: xPadding, bottom: yPadding, right: xPadding)
        super.init(frame: .zero)
        
        self.setupLabel()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect.inset(by: padding))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
//        self.font = UIFont.preferredFont(forTextStyle: .body)
        self.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
    }
    
    func updateColor(newColor: UIColor) {
        self.backgroundColor = newColor
//        self.textColor = self.backgroundColor?.darker(by: 70.0)
    }

    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
}
