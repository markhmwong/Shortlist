//
//  UICollectionViewLayout+Extension.swift
//  Shortlist
//
//  Created by Mark Wong on 31/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

extension UICollectionViewLayout {
	// TaskOptionsViewController.CollectionListConstants.header.rawValue
	// This is collection view in a list format. Only one extra feature is included which is the header title
	// Height sizes are fixed for cells
	func createListLayout(appearance: UICollectionLayoutListConfiguration.Appearance = .insetGrouped, separators: Bool = true, header: Bool = true, headerElementKind: String = TaskOptionsViewController.CollectionListConstants.header.rawValue, footer: Bool = false, footerElementKind: String = "") -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

			var configuration = UICollectionLayoutListConfiguration(appearance: appearance)
			configuration.showsSeparators = separators
			
			let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
			let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44.0))
			
			var suppView: [NSCollectionLayoutBoundarySupplementaryItem] = []
			
			if (header) {
				let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size, elementKind: headerElementKind, alignment: .top)
				suppView.append(headerItem)
			}
			
			if (footer) {
				let footerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size, elementKind: footerElementKind, alignment: .bottom)
				suppView.append(footerItem)
			}
			
			section.boundarySupplementaryItems = suppView
			return section
		}
		return layout
	}
	
	func createListLayoutWithSingleHeader(appearance: UICollectionLayoutListConfiguration.Appearance = .insetGrouped, separators: Bool = true, header: Bool = true, elementKind: String = TaskOptionsViewController.CollectionListConstants.header.rawValue) -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
			
			var configuration = UICollectionLayoutListConfiguration(appearance: appearance)
			configuration.showsSeparators = separators
			configuration.backgroundColor = .clear
			let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
			section.interGroupSpacing = 10.0
			if (header && sectionIndex == 0) {
				let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80.0))
				let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: elementKind, alignment: .top)
				section.boundarySupplementaryItems = [header]
			}
			return section
		}
		return layout
	}
	
	// A vertical scrolling collection view
	func createCollectionViewLayout(header: Bool = false, elementKind: String = "") -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			let estimatedHeight: CGFloat = 10.0

			let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))

			let item = NSCollectionLayoutItem(layoutSize: size)
			item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(20), trailing: nil, bottom: NSCollectionLayoutSpacing.fixed(0))
			
			let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
			group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

			let section = NSCollectionLayoutSection(group: group)
			 
			if (header && sectionIndex == 0 && elementKind != "") {
				let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80.0))
				let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: elementKind, alignment: .top)
				section.boundarySupplementaryItems = [header]
			}
			
			return section
		}
		return layout
	}
}
