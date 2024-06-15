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
        
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                             heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//      
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                              heightDimension: .absolute(44))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
//                                                         subitems: [item])
//      
//        let section = NSCollectionLayoutSection(group: group)
//
//
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        UICollectionViewCompositionalLayout.list(using: config)
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
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
            return section
        }
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.trailingSwipeActionsConfigurationProvider = { indexPath in
            let del = UIContextualAction(style: .destructive, title: "Delete") {
                action, view, completion in
//                self?.delete(at: indexPath)
                completion(true)
            }
            return UISwipeActionsConfiguration(actions: [del])
        }
        return layout
    }
    
    func createCollectionViewListLayout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.trailingSwipeActionsConfigurationProvider = { indexPath in
            let del = UIContextualAction(style: .destructive, title: "Delete") {
                action, view, completion in
                completion(true)
            }
            return UISwipeActionsConfiguration(actions: [del])
        }
        config.leadingSwipeActionsConfigurationProvider = { indexPath in
            let complete = UIContextualAction(style: .normal, title: "Complete") {
                action, view, completion in
                completion(true)
            }
            return UISwipeActionsConfiguration(actions: [complete])
        }
        let layout = UICollectionViewCompositionalLayout.list(using: config)

        return layout
    }
}
