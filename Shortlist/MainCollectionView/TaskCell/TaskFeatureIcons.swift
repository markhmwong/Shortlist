//
//  TaskFeatureIcon.swift
//  Shortlist
//
//  Created by Mark Wong on 7/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class TaskFeatureIcons: UIStackView {
	
	private var neuViewReminder = NeuIcon(frame: .zero, symbol: "deskclock.fill", neumorphic: false)
	
	private var neuViewPhoto = NeuIcon(frame: .zero, symbol: "photo.fill.on.rectangle.fill", neumorphic: false)

	private var neuViewNote = NeuIcon(frame: .zero, symbol: "note.text", neumorphic: false)
	
	private var neuViewLock = NeuIcon(frame: .zero, symbol: "lock.fill", neumorphic: false)
	
//	private var neuViewReminder: UIImageView! = nil
//
//	private var neuViewPhoto: UIImageView! = nil
//
//	private var neuViewNote: UIImageView! = nil
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupProperties()
		setupIcons()
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// view properties
	private func setupProperties() {
		translatesAutoresizingMaskIntoConstraints = false
		alignment = .leading
		distribution = .fillEqually
		axis = .horizontal
		layoutMargins = .zero
		isLayoutMarginsRelativeArrangement = true
	}
	
	private func setupIcons() {
		neuViewReminder.heightAnchor.constraint(equalToConstant: 30).isActive = true
		neuViewReminder.widthAnchor.constraint(equalToConstant: 30).isActive = true

		neuViewPhoto.heightAnchor.constraint(equalToConstant: 30).isActive = true
		neuViewPhoto.widthAnchor.constraint(equalToConstant: 30).isActive = true

		neuViewNote.widthAnchor.constraint(equalToConstant: 30).isActive = true
		neuViewNote.heightAnchor.constraint(equalToConstant: 30).isActive = true
		
		neuViewLock.widthAnchor.constraint(equalToConstant: 30).isActive = true
		neuViewLock.heightAnchor.constraint(equalToConstant: 30).isActive = true
		
		addArrangedSubview(neuViewReminder)
		addArrangedSubview(neuViewPhoto)
		addArrangedSubview(neuViewNote)
		addArrangedSubview(neuViewLock)
		
		setCustomSpacing(5.0, after: neuViewReminder)
		setCustomSpacing(5.0, after: neuViewPhoto)
		setCustomSpacing(5.0, after: neuViewNote)
	}
	
	func enableIcons(with item: TaskItem) {
		neuViewLock.alpha = item.redaction.iconStatus
	}
}



// Circle on the Task cell
class PriorityIndicator: UIView {
	
	// priorityMarkers primitives
	private lazy var innerCircle: UIView = UIView(frame: .zero)
	
	private lazy var outerCircle: UIView = UIView(frame: .zero)
	
	private let priority: Priority
	
	//animation
	
	init(frame: CGRect, priority: Priority) {
		self.priority = priority
		super.init(frame: frame)
		translatesAutoresizingMaskIntoConstraints = false
		setupSubviews()
	}
	
	
	override init(frame: CGRect) {
		self.priority = .high
		super.init(frame: frame)
		setupSubviews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupSubviews() {
		innerCircle.translatesAutoresizingMaskIntoConstraints = false
		innerCircle.clipsToBounds = true
		
		addSubview(innerCircle)
		innerCircle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		innerCircle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		
		defaultPriorityMarkerColor()
	}
	
	private func defaultPriorityMarkerColor() {
		switch priority {
			case .high:
				innerCircle.backgroundColor = .systemRed
			case .medium:
				innerCircle.backgroundColor = .systemOrange
			case .low:
				innerCircle.backgroundColor = .systemBlue
			default:
				innerCircle.backgroundColor = .systemGray
		}
	}
	
	func updatePriorityColor(with newPriority: Priority) {
		switch newPriority {
			case .high:
				innerCircle.backgroundColor = .systemRed
			case .medium:
				innerCircle.backgroundColor = .systemYellow
			case .low:
				innerCircle.backgroundColor = .systemBlue
			default:
				innerCircle.backgroundColor = .systemGray
		}
	}
	
	func animate() {
//		let anim = CABasicAnimation(keyPath: "transform.scale")
//		anim.fromValue = 0.0
//		anim.toValue = 2.0
//		anim.duration = 1.5
//		anim.isRemovedOnCompletion = false
//		anim.fillMode = .forwards
//		anim.repeatCount = Float.greatestFiniteMagnitude
//		outerCircle.layer.add(anim, forKey: nil)
//
//		let animFade = CABasicAnimation(keyPath: "opacity")
//		animFade.fromValue = 1.0
//		animFade.toValue = 0.0
//		animFade.duration = 1.5
//		animFade.isRemovedOnCompletion = false
//		animFade.fillMode = .forwards
//		animFade.repeatCount = Float.greatestFiniteMagnitude
//		outerCircle.layer.add(animFade, forKey: nil)
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		let height = rect.height
		innerCircle.heightAnchor.constraint(equalToConstant: height).isActive = true
		innerCircle.widthAnchor.constraint(equalToConstant: height).isActive = true
		innerCircle.layer.cornerRadius = height / 2
		
//		outerCircle.heightAnchor.constraint(equalToConstant: rect.height).isActive = true
//		outerCircle.widthAnchor.constraint(equalToConstant: rect.width).isActive = true
//		outerCircle.layer.cornerRadius = bounds.height / 2
	}
}
