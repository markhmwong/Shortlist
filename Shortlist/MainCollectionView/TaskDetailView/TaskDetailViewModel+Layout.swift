//
//  TaskDetailViewModel+Layout.swift
//  Shortlist
//
//  Created by Mark Wong on 24/1/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit

extension TaskDetailViewModel {
	// MARK: - Layout each Section
	// create layout
	func createCollectionViewLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			
			//layout each section with sectionIndex
			
			let section = TaskDetailSections.init(rawValue: sectionIndex)
			
			switch section {
				case .title:
					return self.createLayoutForTitleSection()
				case .note:
					return self.createLayoutForNotesSection()
				case .photos:
					return self.createLayoutForPhotoSection()
				default:
					return self.createLayoutForDefaultSection()
			}
		}
		return layout
	}
	
	// MARK: - Specific Layout Configurations
	
	// Default Section Layout
	func createLayoutForDefaultSection() -> NSCollectionLayoutSection {
		let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150.0))

		let item = NSCollectionLayoutItem(layoutSize: size)
		item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(20), trailing: nil, bottom: NSCollectionLayoutSpacing.fixed(0))

		let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
		group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

		let sectionLayout = NSCollectionLayoutSection(group: group)
		return sectionLayout
	}

	// MARK: - Layout reminder
	func createLayoutForReminderSection() -> NSCollectionLayoutSection {
		let estimatedHeight: CGFloat = 50.0

		let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))

		let item = NSCollectionLayoutItem(layoutSize: size)
		item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(20), trailing: nil, bottom: NSCollectionLayoutSpacing.fixed(0))
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
		group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

		let sectionLayout = NSCollectionLayoutSection(group: group)
		return sectionLayout
	}
	
	// MARK: - Layout title Header
	func createLayoutForTitleSection() -> NSCollectionLayoutSection {
		let estimatedHeight: CGFloat = 100.0
		let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
		
		let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))

		let item = NSCollectionLayoutItem(layoutSize: size)
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
		group.contentInsets = contentInsets

		let sectionLayout = NSCollectionLayoutSection(group: group)
		return sectionLayout
	}
	
	// MARK: - Photos layout -
	// includes the footer
	func createLayoutForPhotoSection() -> NSCollectionLayoutSection {
		let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.23), heightDimension: .fractionalWidth(0.23))

		let item = NSCollectionLayoutItem(layoutSize: size)
		item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(10), trailing: nil, bottom: NSCollectionLayoutSpacing.fixed(0))
		item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.3))
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 4)
		group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
		
		// Footer
		let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30.0))
		let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: TaskDetailSupplementaryView.Header, alignment: .top)
		let sectionLayout = NSCollectionLayoutSection(group: group)
		sectionLayout.boundarySupplementaryItems = [header]
		return sectionLayout
	}
	
	// MARK: - Notes Section Layout
	func createLayoutForNotesSection() -> NSCollectionLayoutSection {
		let estimatedHeight: CGFloat = 10.0

		let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))

		let item = NSCollectionLayoutItem(layoutSize: size)
		item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(10), trailing: nil, bottom: NSCollectionLayoutSpacing.fixed(0))
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
		group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
		let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30.0))
		let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: TaskDetailSupplementaryView.Header, alignment: .top)

		let sectionLayout = NSCollectionLayoutSection(group: group)
		sectionLayout.boundarySupplementaryItems = [header]

		return sectionLayout
	}
}
