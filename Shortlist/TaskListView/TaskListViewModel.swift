//
//  TaskListViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 13/4/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit
import CoreData


enum SLTaskListPriority: Int, CaseIterable {
    case high = 0
}

class TaskListViewModel: NSObject {
    
    var coreDataStack: CoreDataStack? = nil
    
    private var diffableDatasource: UICollectionViewDiffableDataSource<SLTaskListPriority, SLTask>! = nil

    private var currentCellEditable: SLTaskCell! = nil
    
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
        
        #if DEBUG
        createMultipleTasks(cds: cds, snapshot: &snapshot)
        #endif
        
        let item = SLTask(context: cds.moc!)
        item.name = "Clean storm drain"
        item.createdAt = Date()
        item.carryOver = false
        item.complete = false
        item.id = UUID()
        snapshot.appendItems([item])
        return snapshot
    }
    
    func printDatasource() {
        print("printing")
        for item in diffableDatasource.snapshot().itemIdentifiers {
            print(item)
        }
    }
    
    
    private func createMultipleTasks(cds: CoreDataStack, snapshot: inout NSDiffableDataSourceSnapshot<SLTaskListPriority, SLTask>) {
        for i in 0...5 {
            let item = SLTask(context: cds.moc!)
            item.name = "Clean storm drain \(i)"
            item.createdAt = Date()
            item.carryOver = false
            item.complete = false
            item.id = UUID()
            snapshot.appendItems([item])
        }
    }
    
    func createTask(completionHandler: @escaping () -> ()) -> NSManagedObjectID {
        let item = SLTask(context: coreDataStack!.moc!)
        item.name = "\(Int.random(in: 0...1000))"
        item.createdAt = Date()
        item.carryOver = false
        item.complete = false
        item.id = UUID()
        var snapshot: NSDiffableDataSourceSnapshot<SLTaskListPriority, SLTask> = diffableDatasource.snapshot()
        snapshot.appendItems([item], toSection: .high)
        
        DispatchQueue.main.async {
            self.diffableDatasource.apply(snapshot)
            completionHandler()
        }
        return item.objectID
    }
    
    func getLastCell(collectionView: UICollectionView) {
        let lastSection = collectionView.numberOfSections - 1
        let lastItem = collectionView.numberOfItems(inSection: lastSection) - 1
        let cell = collectionView.cellForItem(at: IndexPath(item: lastItem, section: lastSection)) as! SLTaskCell
        print(cell.item?.name)
        cell.focusText()
    }
    
    func trackCell(cell: SLTaskCell) {
        currentCellEditable = cell
    }
    
    func resignCurrentCell() {
        guard let cell = currentCellEditable else { return }
        cell.resignFirstResponder()
    }
}
