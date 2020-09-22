//
//  BaseCollectionViewCell.swift
//  Shortlist
//
//  Created by Mark Wong on 4/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//
//	Maintains background consistency

import UIKit

class BaseCollectionView: UICollectionView {
	
	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: layout)
		backgroundColor = ThemeV2.Background
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class BaseCollectionViewController: UICollectionViewController {
	
	override init(collectionViewLayout layout: UICollectionViewLayout) {
		super.init(collectionViewLayout: layout)
		collectionView.backgroundColor = ThemeV2.Background
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
