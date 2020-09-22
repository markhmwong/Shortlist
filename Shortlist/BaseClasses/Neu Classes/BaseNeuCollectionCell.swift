//
//  BaseNeuCollectionCell.swift
//  Shortlist
//
//  Created by Mark Wong on 4/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

// MARK: - Neumorphic Style Collection View Cell
class BaseNeuCollectionViewCell<T: Equatable>: UICollectionViewCell, BaseCellProtocol, NeumorphicShadow {
	
	private var lightShadow: CALayer? = nil
	
	private var darkShadow: CALayer? = nil
	
	var item: T? = nil
	
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
//		castNeumorphicShadow()
	}
	
	internal func setupCellProperties() {
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = UIColor.clear
		clipsToBounds = true
		layer.cornerRadius = 14.0
	}
	
	internal func setupCellViews() {
//		guard darkShadow == nil, lightShadow == nil else {
//			return
//		}
//		darkShadow = CALayer()
//		lightShadow = CALayer()
//		layer.insertSublayer(darkShadow!, at: 0)
//		layer.insertSublayer(lightShadow!, at: 0)
//
//		contentView.addSubview(headerContainer)
//		headerContainer.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//		headerContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0).isActive = true
//		headerContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0).isActive = true
//		headerContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15.0).isActive = true

	}
	
	// Neumorphic lighting
	internal func castNeumorphicShadow() {
		layer.masksToBounds = true

		let cornerRadius: CGFloat = 14.0
		let shadowRadius: CGFloat = 8.0

		if let ds = darkShadow {
			ds.frame = bounds
			ds.backgroundColor = UIColor.white.cgColor
			ds.shadowColor = UIColor.black.cgColor
			ds.cornerRadius = cornerRadius
			ds.masksToBounds = false
			ds.shadowOffset = CGSize(width: shadowRadius, height: shadowRadius)
			ds.shadowOpacity = 0.2
			ds.shadowRadius = shadowRadius
			
		}
		
		if let ls = lightShadow {
			ls.frame = bounds
			ls.backgroundColor = UIColor.white.cgColor
			ls.shadowColor = UIColor.white.cgColor
			ls.masksToBounds = false
			ls.cornerRadius = cornerRadius
			ls.shadowOffset = CGSize(width: -shadowRadius, height: -shadowRadius)
			ls.shadowOpacity = 0.75
			ls.shadowRadius = shadowRadius
			
		}
	}
	
	func configureCell(with item: T) {
		guard self.item != item else { return }
		self.item = item
	}
}
