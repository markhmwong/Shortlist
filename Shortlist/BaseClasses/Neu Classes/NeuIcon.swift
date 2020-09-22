//
//  NeuIcon.swift
//  Shortlist
//
//  Created by Mark Wong on 5/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class NeuIcon: UIView {
	
	private let darkShadow: CALayer = CALayer()
	
	private let lightShadow: CALayer = CALayer()
	
	private var icon: UIImageView
	
	private var neumorphicState: Bool = true
	
	init(frame: CGRect, symbol: String, neumorphic: Bool = true) {
		// Initialise
		self.neumorphicState = neumorphic
		
		let config = UIImage.SymbolConfiguration(pointSize: 12.0)
		let image = UIImage(systemName: symbol, withConfiguration: config)
		icon = UIImageView(image: image)
		icon.contentMode = .scaleAspectFit
		icon.translatesAutoresizingMaskIntoConstraints = false
		icon.tintColor = UIColor.red.lighter(by: 20.0)!
		
		super.init(frame: frame)

		// View properties
		translatesAutoresizingMaskIntoConstraints = false
		clipsToBounds = true
		layoutMargins = .zero
//		backgroundColor = .offWhite
		
//		layer.borderColor = UIColor.red.lighter(by: 40.0)!.cgColor
//		layer.borderWidth = 1.0

		setupSubViews()
	}
	
	override init(frame: CGRect) {
		let config = UIImage.SymbolConfiguration(pointSize: 12.0)
		let image = UIImage(systemName: "deskclock.fill", withConfiguration: config)
		icon = UIImageView(image: image)
		icon.contentMode = .scaleAspectFill
		icon.translatesAutoresizingMaskIntoConstraints = false
		icon.tintColor = UIColor.red.lighter(by: 40.0)!
		super.init(frame: frame)

		// View properties
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = .offWhite
		clipsToBounds = true
		layer.borderWidth = 2.0
		layer.borderColor = UIColor.red.lighter(by: 40.0)!.cgColor
		setupSubViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		layer.cornerRadius = bounds.height / 2
//		if (neumorphicState) {
//			castNeumorphicShadow()
//		}
		
//		castInnerNeumorphicShadow()
	}
	
	private func setupSubViews() {
		addSubview(icon)
		icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
	}
	
	// Neumorphic lighting
	private func castNeumorphicShadow() {
		layer.masksToBounds = false

		let cornerRadius: CGFloat = bounds.height / 2
		let shadowRadius: CGFloat = 4.0
		
		darkShadow.frame = bounds
		darkShadow.backgroundColor = UIColor.offWhite.cgColor
		darkShadow.shadowColor = UIColor.black.cgColor
		darkShadow.cornerRadius = cornerRadius
		darkShadow.shadowOffset = CGSize(width: shadowRadius, height: shadowRadius)
		darkShadow.shadowOpacity = 0.10
		darkShadow.shadowRadius = shadowRadius
		layer.insertSublayer(darkShadow, at: 0)
		
		lightShadow.frame = bounds
		lightShadow.backgroundColor = UIColor.offWhite.cgColor
		lightShadow.shadowColor = UIColor.white.cgColor
		lightShadow.cornerRadius = cornerRadius
		lightShadow.shadowOffset = CGSize(width: -shadowRadius, height: -shadowRadius)
		lightShadow.shadowOpacity = 0.75
		lightShadow.shadowRadius = shadowRadius
		layer.insertSublayer(lightShadow, at: 0)
	}
	
	func castInnerNeumorphicShadow() {

		let innerShadowLayerW = CALayer()
		innerShadowLayerW.frame = self.bounds
		let pathW = UIBezierPath(rect: innerShadowLayerW.bounds.insetBy(dx: -4, dy: -4))

		let innerPartW = UIBezierPath.init(roundedRect: innerShadowLayerW.bounds, cornerRadius: 3.0).reversing()
		pathW.append(innerPartW)
		innerShadowLayerW.shadowPath = pathW.cgPath
		innerShadowLayerW.masksToBounds = true
		innerShadowLayerW.shadowColor = UIColor.white.cgColor
		innerShadowLayerW.shadowOffset = CGSize(width: 3, height: 2)
		innerShadowLayerW.shadowOpacity = 0.78
		innerShadowLayerW.shadowRadius = 4.0
		layer.addSublayer(innerShadowLayerW)

		let innerShadowLayer = CALayer()
		innerShadowLayer.frame = self.bounds
		let path = UIBezierPath(rect: innerShadowLayer.bounds.insetBy(dx: -4, dy: -4))

		let innerPart = UIBezierPath.init(roundedRect: innerShadowLayer.bounds, cornerRadius: 3.0).reversing()
		path.append(innerPart)
		innerShadowLayer.shadowPath = path.cgPath
		innerShadowLayer.masksToBounds = true
		innerShadowLayer.shadowColor = UIColor.black.cgColor
		innerShadowLayer.shadowOffset = CGSize(width: 4, height: 2)
		innerShadowLayer.shadowOpacity = 0.1
		innerShadowLayer.shadowRadius = 4.0
		layer.addSublayer(innerShadowLayer)
	}
}
