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
    // TODO: register cell in enum fashion. create a protocol Registable around this concept
    
    var coreDataStack: CoreDataStack? = nil
    
    private var diffableDatasource: UICollectionViewDiffableDataSource<SLTaskListPriority, SLTask>! = nil
    
    private var currentCellEditable: SLTaskCell! = nil
    
    private var data: [SLTask] = []
    
    init(coreDataStack: CoreDataStack? = nil) {
        self.coreDataStack = coreDataStack
        super.init()
    }
    
    func configureDatasource(view: UICollectionView) {
        let taskCellRegistration = UICollectionView.CellRegistration<SLTaskCell, SLTask>.registerTaskCell()
        
        diffableDatasource = UICollectionViewDiffableDataSource<SLTaskListPriority, SLTask>(collectionView: view) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: taskCellRegistration, for: indexPath, item: item)
        }
        
        //        diffableDatasource.apply(configureSnapshot(data: data))
    }
    
    func updateSnapshot(fetchedResultsController: NSFetchedResultsController<SLTask>) {
        if let fetchedObjects = fetchedResultsController.fetchedObjects {
            let snapshot = configureSnapshot(data: fetchedObjects)
            diffableDatasource.apply(snapshot)
        }
    }
    
    func refreshDatasource(fetchedResultsController: NSFetchedResultsController<SLTask>) {
        if let fetchedObjects = fetchedResultsController.fetchedObjects {
            let snapshot = configureSnapshot(data: fetchedObjects)
            diffableDatasource.applySnapshotUsingReloadData(snapshot)
        }
    }
    
    private func configureSnapshot(data: [SLTask]) -> NSDiffableDataSourceSnapshot<SLTaskListPriority, SLTask> {
        var snapshot = NSDiffableDataSourceSnapshot<SLTaskListPriority, SLTask>()
        snapshot.appendSections(SLTaskListPriority.allCases)
        
        snapshot.appendItems(data)
        
        return snapshot
    }
    
    func printDatasource() {
        print("printing")
        for item in diffableDatasource.snapshot().itemIdentifiers {
            print(item)
        }
        
    }
    
    func fetchData() -> [SLTask] {
        guard let cds = coreDataStack else {
            return []
        }
        return cds.fetchTodaysItems()
    }
    
    func createMultipleMockTasks() {
        // testings purposes
        guard let cds = coreDataStack else {
            return
        }
        if cds.fetchTodaysItems().count == 0 {
            cds.createMockItems()
        }
    }
    
    func applySnapshot(fetchedResultsController: NSFetchedResultsController<SLTask>) {
        var snapshot = NSDiffableDataSourceSnapshot<SLTaskListPriority, SLTask>()
        snapshot.appendSections([.high])
        
        if let tasks = fetchedResultsController.fetchedObjects {
            snapshot.appendItems(tasks, toSection: .high)
        }
        
        diffableDatasource.apply(snapshot, animatingDifferences: true)
    }
    
    
    func getLastCell(collectionView: UICollectionView) -> SLTaskCell {
        let lastSection = collectionView.numberOfSections - 1
        let lastItem = collectionView.numberOfItems(inSection: lastSection) - 1
        return collectionView.cellForItem(at: IndexPath(item: lastItem, section: lastSection)) as! SLTaskCell
        
    }
    
    func trackCell(cell: SLTaskCell) {
        currentCellEditable = cell
    }
    
    func resignCurrentCell() {
        guard let cell = currentCellEditable else { return }
        cell.resignFirstResponder()
    }
    
    /// testing only
    func createTask() {
#if DEBUG
        assert(coreDataStack != nil)
        assert(coreDataStack?.moc != nil)
#endif
        guard
            let cds = coreDataStack,
            let moc = cds.moc
        else {
            return
        }
        let slTask = SLTask(context: moc)
        slTask.newTask(name: "test")
        
        cds.saveContext()
    }
    
    /// testing only
    func deleteAllTasks() {
#if DEBUG
        assert(coreDataStack != nil)
        assert(coreDataStack?.moc != nil)
#endif
        guard
            let cds = coreDataStack
        else {
            return
        }
        
        cds.deleteAllObjects()
        
        cds.saveContext()
    }
}
