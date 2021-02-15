//
//  BaseCell.swift
//  Shortlist
//
//  Created by Mark Wong on 29/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

protocol BaseCellProtocol {
	func setupCellProperties()
	func setupCellViews()
}

//protocol BaseCellLabels {
//	var staticTitleLabel: BaseStaticLabel { get set }
//}

protocol NeumorphicShadow {
	associatedtype T
	func castNeumorphicShadow()
	func configureCell(with item: T)
}

// Supports use of custom states. Please find the WhatsNewCell/PermissionCell as an example of usage
class BaseCell<T: Equatable>: UICollectionViewCell {
	
	var item: T? = nil
	
	let textColor: UIColor = .black
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		layer.cornerRadius = 0.0
		layer.masksToBounds = true
		layer.shouldRasterize = true
		layer.rasterizationScale = UIScreen.main.scale
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configureCell(with item: T) {
		guard self.item != item else { return }
		self.item = item
		setNeedsUpdateConfiguration()
	}
}

// MARK: Standard Base Cell
class BaseCollectionViewCell<T>: UICollectionViewCell, BaseCellProtocol {
	
	private var item: T?
	
	private var staticTitleLabel: BaseStaticLabel = BaseStaticLabel(frame: .zero)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupCellViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	internal func setupCellViews() {
		backgroundColor = .clear//ThemeV2.CellProperties.Background
	}
	
	internal func setupCellProperties() {
		
	}
	
	func configureCell(with item: T) {
		
	}
}

// MARK: Standard Base List Cell
class BaseTableListCell<T>: UICollectionViewListCell, BaseCellProtocol {
	func setupCellProperties() {
		
	}
	
	func setupCellViews() {
		
	}
}

// remove - to do
class BaseListTipCell: UICollectionViewCell {
	
	private var lightShadow: CALayer? = nil
	
	private var darkShadow: CALayer? = nil
	
	private var item: TipItem? = nil
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = UIColor.offWhite
		clipsToBounds = true
		layer.cornerRadius = 14.0
		layer.backgroundColor = UIColor.clear.cgColor
		backgroundColor = UIColor.clear
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
//		castNeumorphicShadow()
	}
	
	private func castNeumorphicShadow() {
		layer.masksToBounds = false
		
		let cornerRadius: CGFloat = 14.0
		let shadowRadius: CGFloat = 4.0

		if let ds = darkShadow {
			ds.frame = bounds
			ds.backgroundColor = ThemeV2.CellProperties.Background.cgColor
			ds.shadowColor = UIColor.black.cgColor
			ds.cornerRadius = cornerRadius
			ds.shadowOffset = CGSize(width: shadowRadius, height: shadowRadius)
			ds.shadowOpacity = 0.2
			ds.shadowRadius = shadowRadius
			
		}
		
		if let ls = lightShadow {
			ls.frame = bounds
			ls.backgroundColor = ThemeV2.CellProperties.Background.cgColor
			ls.shadowColor = UIColor.white.cgColor
			ls.cornerRadius = cornerRadius
			ls.shadowOffset = CGSize(width: -shadowRadius, height: -shadowRadius)
			ls.shadowOpacity = 0.20
			ls.shadowRadius = shadowRadius
			
		}
	}
	
	func configureCell(with item: TipItem) {
		guard darkShadow == nil, lightShadow == nil else {
			return
		}
		darkShadow = CALayer()
		lightShadow = CALayer()
		layer.insertSublayer(darkShadow!, at: 0)
		layer.insertSublayer(lightShadow!, at: 0)
		
		guard self.item != item else { return }
		self.item = item
		setNeedsUpdateConfiguration()
	}
	
	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.tipItem = self.item
		return state
	}
}


// MARK: - Base List Cell.
// Supports use of custom states. Please find the WhatsNewCell/PermissionCell as an example of usage
class BaseListCell<T: Equatable>: UICollectionViewListCell {
	
	var item: T? = nil
	
	let textColor: UIColor = ThemeV2.TextColor.DefaultColor
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configureCell(with item: T) {
		guard self.item != item else { return }
		self.item = item
		setNeedsUpdateConfiguration()
	}
}
