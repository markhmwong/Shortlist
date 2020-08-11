//
//  NeuButton.swift
//  Shortlist
//
//  Created by Mark Wong on 1/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class NeuButton: UIButton {
	
	private let darkShadow = CALayer()
	
	private let lightShadow = CALayer()
	
	init(title: String) {
		super.init(frame: .zero)
		setTitle("\(title)", for: .normal)
		titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2).with(weight: .bold)
		translatesAutoresizingMaskIntoConstraints = false
		setTitleColor(.black, for: .normal)
		layer.cornerRadius = 16.0
		backgroundColor = UIColor.offWhite
		clipsToBounds = true
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		layer.cornerRadius = 16.0
		backgroundColor = UIColor.offWhite
		clipsToBounds = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
//		layer.backgroundColor = UIColor.clear.cgColor

		imageView?.isUserInteractionEnabled = false
		
		layer.masksToBounds = false

		let cornerRadius: CGFloat = 9.0
		let shadowRadius: CGFloat = 6.0
		
		darkShadow.frame = bounds
		darkShadow.backgroundColor = backgroundColor?.cgColor
		darkShadow.shadowColor = UIColor.black.lighter(by: 90)!.cgColor
		darkShadow.cornerRadius = cornerRadius
		darkShadow.shadowOffset = CGSize(width: shadowRadius, height: shadowRadius)
		darkShadow.shadowOpacity = 1.0
		darkShadow.shadowRadius = shadowRadius
		layer.insertSublayer(darkShadow, at: 0)

		
		lightShadow.frame = bounds
		lightShadow.backgroundColor = UIColor.white.cgColor
		lightShadow.shadowColor = UIColor.white.cgColor
		lightShadow.cornerRadius = cornerRadius
		lightShadow.shadowOffset = CGSize(width: -shadowRadius, height: -shadowRadius)
		lightShadow.shadowOpacity = 1.0
		lightShadow.shadowRadius = shadowRadius
		layer.insertSublayer(lightShadow, at: 0)
	}
	
	func pressedAnimation() {
		let pressedAnimation = CABasicAnimation(keyPath: "shadowOpacity")
		pressedAnimation.duration = 0.4
		pressedAnimation.fromValue = 0.3
		pressedAnimation.toValue = lightShadow.shadowOpacity
		pressedAnimation.isRemovedOnCompletion = false
		pressedAnimation.fillMode = .forwards

		let depressedAnimation = CABasicAnimation(keyPath: "shadowOpacity")
		depressedAnimation.duration = 0.15
		depressedAnimation.fromValue = lightShadow.shadowOpacity
		depressedAnimation.toValue = 0.3
		depressedAnimation.isRemovedOnCompletion = false
		depressedAnimation.fillMode = .forwards

		let animationGroup = CAAnimationGroup()
		animationGroup.duration = depressedAnimation.duration + pressedAnimation.duration
		animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
		animationGroup.animations = [depressedAnimation, pressedAnimation]

		// apply animation to both shadows
		lightShadow.add(animationGroup, forKey: "pressedAnimation")
		darkShadow.add(animationGroup, forKey: "pressedAnimation")
		
		let translateY = CABasicAnimation(keyPath: "transform.translation.y")
		translateY.duration = 0.30
		translateY.fromValue = 0.0
		translateY.toValue = -2.0
		translateY.isRemovedOnCompletion = false
		translateY.fillMode = .forwards
		
		titleLabel?.layer.add(translateY, forKey: "TranslateY_TitleLabel")
	}
	
	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		let newArea = CGRect(
			x: self.bounds.origin.x - 5.0,
			y: self.bounds.origin.y - 5.0,
			width: self.bounds.size.width + 5.0,
			height: self.bounds.size.height + 10.0
		)
		return newArea.contains(point)
	}
	
}

extension NeuButton: CAAnimationDelegate {
	func animationDidStart(_ anim: CAAnimation) {
		//
	}
}
