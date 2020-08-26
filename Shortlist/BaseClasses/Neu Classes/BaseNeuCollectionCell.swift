//
//  BaseNeuCollectionCell.swift
//  Shortlist
//
//  Created by Mark Wong on 4/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

// MARK: - Neumorphic Style Collection View Cell
class BaseNeuCollectionViewCell<T>: UICollectionViewCell, BaseCellProtocol, NeumorphicShadow {
	
	private var lightShadow: CALayer? = nil
	
	private var darkShadow: CALayer? = nil
	
	private var item: T?
	
	lazy var headerContainer: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .clear
		return view
	}()
	
	lazy var bodyContainer: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .clear
		return view
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupCellProperties()
		self.setupCellViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Override draw
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		castNeumorphicShadow()
	}
	
	internal func setupCellProperties() {
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = UIColor.offWhite
		clipsToBounds = true
		layer.cornerRadius = 14.0
	}
	
	internal func setupCellViews() {
		guard darkShadow == nil, lightShadow == nil else {
			return
		}
		darkShadow = CALayer()
		lightShadow = CALayer()
		layer.insertSublayer(darkShadow!, at: 0)
		layer.insertSublayer(lightShadow!, at: 0)

		contentView.addSubview(headerContainer)
		headerContainer.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		headerContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0).isActive = true
		headerContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0).isActive = true
		headerContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15.0).isActive = true
//
//		contentView.addSubview(bodyContainer)
//		bodyContainer.topAnchor.constraint(equalTo: headerContainer.bottomAnchor).isActive = true
//		bodyContainer.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor).isActive = true
//		bodyContainer.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor).isActive = true
//		bodyContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
	}
	
	// Neumorphic lighting
	internal func castNeumorphicShadow() {
		layer.masksToBounds = false

		let cornerRadius: CGFloat = 14.0
		let shadowRadius: CGFloat = 8.0

		if let ds = darkShadow {
			ds.frame = bounds
			ds.backgroundColor = UIColor.offWhite.cgColor
			ds.shadowColor = UIColor.black.cgColor
			ds.cornerRadius = cornerRadius
			ds.shadowOffset = CGSize(width: shadowRadius, height: shadowRadius)
			ds.shadowOpacity = 0.2
			ds.shadowRadius = shadowRadius
			
		}
		
		if let ls = lightShadow {
			ls.frame = bounds
			ls.backgroundColor = UIColor.offWhite.cgColor
			ls.shadowColor = UIColor.white.cgColor
			ls.cornerRadius = cornerRadius
			ls.shadowOffset = CGSize(width: -shadowRadius, height: -shadowRadius)
			ls.shadowOpacity = 0.75
			ls.shadowRadius = shadowRadius
			
		}
	}
	
	func configureCell(with item: T) {
		
	}
}
