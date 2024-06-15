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
    
    func refreshDatasource(with item: SLTask) {
        let objectToUpdate = data.first { task in
            return task.objectID == item.objectID
        }
        
        objectToUpdate?.complete = item.complete
        
        let snapshot = configureSnapshot(data: data)
        diffableDatasource.applySnapshotUsingReloadData(snapshot)
    }
    
    func configureDatasource(view: UICollectionView) {
        let taskCellRegistration = UICollectionView.CellRegistration<SLTaskCell, SLTask>.registerTaskCell()

        diffableDatasource = UICollectionViewDiffableDataSource<SLTaskListPriority, SLTask>(collectionView: view) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: taskCellRegistration, for: indexPath, item: item)
        }
        
        diffableDatasource.apply(configureSnapshot(data: data))
    }
    
    private func configureSnapshot(data: [SLTask]) -> NSDiffableDataSourceSnapshot<SLTaskListPriority, SLTask> {
        var snapshot = NSDiffableDataSourceSnapshot<SLTaskListPriority, SLTask>()
        snapshot.appendSections(SLTaskListPriority.allCases)
        
//        guard let cds = coreDataStack else {
//            print("unable to load core data stack")
//            snapshot.appendItems([])
//            return snapshot
//        }
        
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
        guard let cds = coreDataStack else { return }
        for i in 0...5 {
            let item = SLTask(context: cds.moc!)
            item.name = "Clean storm drain \(i)"
            item.createdAt = Date()
            item.carryOver = false
            item.complete = false
            item.id = UUID()
            data.append(item)
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
}
