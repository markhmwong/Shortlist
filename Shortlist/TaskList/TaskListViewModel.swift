//
//  TaskListViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 13/4/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit
import CoreData
import WidgetKit

enum TaskListItem: Hashable {
    case task(SLTask)
    case placeholder(index: Int)
}

class TaskListViewModel: NSObject {

    enum SLTaskListPriority: Int, CaseIterable {
        case main = 0
    }

    static let taskLimit = 3

    private let coreDataStack: CoreDataStack?

    private var diffableDatasource: UICollectionViewDiffableDataSource<SLTaskListPriority, TaskListItem>!

    init(coreDataStack: CoreDataStack? = nil) {
        self.coreDataStack = coreDataStack
        super.init()
    }

    func configureDatasource(view: UICollectionView) {
        let taskCellReg = UICollectionView.CellRegistration<SLTaskCell, TaskListItem> { cell, _, item in
            if case .task(let task) = item {
                cell.configureCell(with: task)
            }
        }
        let placeholderCellReg = UICollectionView.CellRegistration<PlaceholderTaskCell, TaskListItem> { _, _, _ in }

        diffableDatasource = UICollectionViewDiffableDataSource<SLTaskListPriority, TaskListItem>(collectionView: view) { collectionView, indexPath, item in
            switch item {
            case .task:
                return collectionView.dequeueConfiguredReusableCell(using: taskCellReg, for: indexPath, item: item)
            case .placeholder:
                return collectionView.dequeueConfiguredReusableCell(using: placeholderCellReg, for: indexPath, item: item)
            }
        }
    }

    private func makeSnapshot(tasks: [SLTask]) -> NSDiffableDataSourceSnapshot<SLTaskListPriority, TaskListItem> {
        var snapshot = NSDiffableDataSourceSnapshot<SLTaskListPriority, TaskListItem>()
        snapshot.appendSections(SLTaskListPriority.allCases)
        var items: [TaskListItem] = tasks.map { .task($0) }
        let placeholderCount = max(0, TaskListViewModel.taskLimit - tasks.count)
        for i in 0..<placeholderCount {
            items.append(.placeholder(index: i))
        }
        snapshot.appendItems(items)
        return snapshot
    }

    func updateSnapshot(fetchedResultsController: NSFetchedResultsController<SLTask>) {
        let tasks = fetchedResultsController.fetchedObjects ?? []
        diffableDatasource.apply(makeSnapshot(tasks: tasks))
    }

    func refreshDatasource(fetchedResultsController: NSFetchedResultsController<SLTask>) {
        let tasks = fetchedResultsController.fetchedObjects ?? []
        diffableDatasource.applySnapshotUsingReloadData(makeSnapshot(tasks: tasks))
    }

    func applySnapshot(fetchedResultsController: NSFetchedResultsController<SLTask>) {
        let tasks = fetchedResultsController.fetchedObjects ?? []
        diffableDatasource.apply(makeSnapshot(tasks: tasks), animatingDifferences: true)
    }

    func item(at indexPath: IndexPath) -> TaskListItem? {
        diffableDatasource.itemIdentifier(for: indexPath)
    }

    func canAddTask() -> Bool {
        let taskCount = diffableDatasource.snapshot().itemIdentifiers.filter {
            if case .task = $0 { return true }
            return false
        }.count
        return taskCount < TaskListViewModel.taskLimit
    }

    func completeTask(_ task: SLTask) {
        task.taskToStatus?.name = TaskStatus.Complete.rawValue
        coreDataStack?.saveContext()
        NotificationService.shared.cancelReminder(for: task)
        WidgetCenter.shared.reloadAllTimelines()
    }

    // MARK: - Debug

    #if DEBUG
    func createMultipleMockTasks() {
        guard let cds = coreDataStack else { return }
        if cds.fetchTodaysItems().isEmpty {
            cds.createMockItems()
        }
    }

    func createTask() {
        guard let cds = coreDataStack, let moc = cds.moc else { return }
        let task = SLTask(context: moc)
        task.newTask(name: "Test goal \(Int.random(in: 0...99))")
        cds.saveContext()
    }

    func deleteAllTasks() {
        coreDataStack?.deleteAllObjects()
        coreDataStack?.saveContext()
    }
    #endif

    func getLastCell(collectionView: UICollectionView) -> SLTaskCell? {
        let lastSection = collectionView.numberOfSections - 1
        let lastItem = collectionView.numberOfItems(inSection: lastSection) - 1
        guard lastItem >= 0 else { return nil }
        return collectionView.cellForItem(at: IndexPath(item: lastItem, section: lastSection)) as? SLTaskCell
    }
}
