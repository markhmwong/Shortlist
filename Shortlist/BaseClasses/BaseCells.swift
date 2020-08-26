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
		backgroundColor = UIColor.offWhite
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
