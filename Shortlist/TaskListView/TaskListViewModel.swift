//
//  TaskListViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 13/4/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

enum SLTaskListPriority: Int, CaseIterable {
    case high = 0
    case med
    case low
}

class TaskListViewModel: NSObject {
    
    var coreDataStack: CoreDataStack? = nil
    
    private var diffableDatasource: UICollectionViewDiffableDataSource<SLTaskListPriority, SLTask>! = nil

    init(coreDataStack: CoreDataStack? = nil) {
        self.coreDataStack = coreDataStack
        super.init()
    }
    
    func configureDatasource(view: UICollectionView) {
        let taskCellRegistration = UICollectionView.CellRegistration<SLTaskCell, SLTask>.registerTaskCell()

        diffableDatasource = UICollectionViewDiffableDataSource<SLTaskListPriority, SLTask>(collectionView: view) { collectionView, indexPath, item in
            let cell = collectionView.dequeueConfiguredReusableCell(using: taskCellRegistration, for: indexPath, item: item)
            cell.configureCell(with: item)
            return cell
        }
        diffableDatasource.apply(configureSnapshot())
    }
    
    private func configureSnapshot() -> NSDiffableDataSourceSnapshot<SLTaskListPriority, SLTask> {
        var snapshot = NSDiffableDataSourceSnapshot<SLTaskListPriority, SLTask>()
        snapshot.appendSections(SLTaskListPriority.allCases)
        
        guard let cds = coreDataStack else {
            print("unable to load core data stack")
            snapshot.appendItems([])
            return snapshot
        }
        
        let item = SLTask(context: coreDataStack!.moc!)
        item.name = "Clean storm drain"
        item.createdAt = Date()
        item.carryOver = false
        item.complete = false
        item.id = 0
        snapshot.appendItems([item])
        return snapshot
    }
    
}
