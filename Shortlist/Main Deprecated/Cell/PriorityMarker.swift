//
//  PriorityMarker.swift
//  Shortlist
//
//  Created by Mark Wong on 23/12/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class PriorityMarker: UIView {
	
	let gradientLayer: CAGradientLayer = CAGradientLayer()
	
	var colorBands: [UIView] = []
	
	var prevViewTrailingAnchor: NSLayoutXAxisAnchor? = nil
	
	init() {
		super.init(frame: .zero)
		self.setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupView() {
		translatesAutoresizingMaskIntoConstraints = false
		clipsToBounds = true
		
		self.gradientLayer.colors = [Theme.Priority.mediumColor.adjust(by: -15.0)!.cgColor, Theme.Priority.mediumColor.adjust(by: 20.0)!.cgColor]
		gradientLayer.locations = [0.0, 0.2, 0.4, 0.6, 0.8]
		gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
		gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()

		layer.cornerRadius = self.bounds.height / 4.0
		gradientLayer.frame = CGRect(x: 10.0, y: 5.0, width: self.bounds.width - 20.0, height: self.bounds.height / 3.0)
		self.layer.addSublayer(gradientLayer)
	}
	
	func updateGradient(color: UIColor) {
		DispatchQueue.main.async {
			self.gradientLayer.colors = [color.adjust(by: 0.0)!.cgColor, color.adjust(by: 0.0)!.cgColor, color.adjust(by: -10.0)!.cgColor, color.adjust(by: -20.0)!.cgColor, color.adjust(by: -30.0)!.cgColor, color.adjust(by: -40.0)!.cgColor]
		}
	}
}
