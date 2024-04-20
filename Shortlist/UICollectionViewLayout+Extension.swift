//
//  UICollectionViewLayout+Extension.swift
//  Shortlist
//
//  Created by Mark Wong on 13/4/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

extension UICollectionViewLayout {
    
    func createCollectionViewSectionHeaderLayout(header: Bool = false, elementKind: String = "", itemSpace: NSDirectionalEdgeInsets, groupSpacing: NSDirectionalEdgeInsets, cellHeight: NSCollectionLayoutDimension = .absolute(60.0), sectionSpacing: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            //            let estimatedHeight: CGFloat = cellHeight // cell height
            
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: cellHeight)
            
            let item = NSCollectionLayoutItem(layoutSize: size)
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: NSCollectionLayoutSpacing.fixed(0), top: NSCollectionLayoutSpacing.fixed(10), trailing: NSCollectionLayoutSpacing.fixed(0), bottom: NSCollectionLayoutSpacing.fixed(0))
            item.contentInsets = itemSpace
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
            
            let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .estimated(44))
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
//            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//                layoutSize: headerFooterSize,
//                elementKind: TipJarViewController.sectionElementKind, alignment: .top)
//            section.boundarySupplementaryItems = [sectionHeader]
            //            if (header && sectionIndex == 0 && elementKind != "") {
            //                let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80.0))
            //                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: elementKind, alignment: .top)
            //                section.boundarySupplementaryItems = [header]
            //            }
            
            return section
        }
        return layout
    }
    
}
