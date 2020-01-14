//
//  Circle.swift
//  Shortlist
//
//  Created by Mark Wong on 25/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class CircularProgressBar: CAShapeLayer {
	
	override init() {
		super.init()
		setupShape()
	}
	
	override init(layer: Any) {
		super.init(layer: layer)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	private func setupShape() {
        self.path = path
		self.strokeColor = UIColor.white.cgColor
		self.fillColor = UIColor.clear.cgColor
        self.lineCap = .round
		self.lineWidth = 2.5
        self.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
		self.strokeEnd = 0.0
	}
	
}
