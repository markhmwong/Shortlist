//
//  TaskListViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 13/4/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit
import CoreData
import WhizUtilKit

class TaskListViewModel: NSObject, DatasourceSupervisorForCoreData {
    
    typealias Item = SLTask
    typealias SectionIdentifier = SLTaskListPriority
    
    enum SLTaskListPriority: Int, CaseIterable {
        case high = 0
    }
    
    private let settingsManager: SettingsManager = SettingsManager.shared
    // TODO: register cell in enum fashion. create a protocol Registable around this concept
    
    // create a singleton for settings
    // -1 means this hasn't been initialised properly
    private var taskLimit: Int16 = -1
    
    private var coreDataStack: CoreDataStack? = nil
    
    private var diffableDatasource: UICollectionViewDiffableDataSource<SLTaskListPriority, SLTask>! = nil
    
    private var currentCellEditable: SLTaskCell! = nil
    
    init(coreDataStack: CoreDataStack? = nil) {
        self.coreDataStack = coreDataStack
        super.init()
        initialiseTaskLimit()
    }
    
    private func initialiseTaskLimit() {
        taskLimit = settingsManager.fetchTaskLimit()
		
        #if DEBUG
        assert(taskLimit != -1)
        #endif
    }
    
    func configureDatasource(view: UICollectionView) {
        let taskCellRegistration = UICollectionView.CellRegistration<SLTaskCell, SLTask>.registerTaskCell()
        
        diffableDatasource = UICollectionViewDiffableDataSource<SLTaskListPriority, SLTask>(collectionView: view) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: taskCellRegistration, for: indexPath, item: item)
        }
    }
    
    internal func configureSnapshot(data: [SLTask]) -> NSDiffableDataSourceSnapshot<SLTaskListPriority, SLTask> {
        var snapshot = NSDiffableDataSourceSnapshot<SLTaskListPriority, SLTask>()
        snapshot.appendSections(SLTaskListPriority.allCases)
        
        snapshot.appendItems(data)
        
        return snapshot
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
    

    
    public func printDatasource() {
        print("printing")
        for item in diffableDatasource.snapshot().itemIdentifiers {
            print(item)
        }
        
    }
    
    public func createMultipleMockTasks() {
        // testings purposes
        guard let cds = coreDataStack else {
            return
        }
        if cds.fetchTodaysItems().count == 0 {
            cds.createMockItems()
        }
    }
    
    public func applySnapshot(fetchedResultsController: NSFetchedResultsController<SLTask>) {
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
    
    public func trackCell(cell: SLTaskCell) {
        currentCellEditable = cell
    }
    
    public func resignCurrentCell() {
        guard let cell = currentCellEditable else { return }
        cell.resignFirstResponder()
    }
    
    /// testing only
    public func createTask() {
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
        slTask.newTask(name: "Testing a longer string for the title that may wrap or may not wrap")
        
        cds.saveContext()
    }
    
    /// testing only
    public func deleteAllTasks() {
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
    
    public func taskLimitReached() -> Bool {
        let numTasks = diffableDatasource.snapshot().numberOfItems
        
        if numTasks < taskLimit {
            return true
        } else {
            return false
        }
    }
    
    public func limitTasks(_ newLimit: Int16) {
        /// check didSet of taskLimit property to see that it is set in CoreData
        taskLimit = newLimit
    }
}
