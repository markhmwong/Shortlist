//
//  TaskListViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 23/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

extension TaskListViewController: RefreshablePopView {
    func refresh(item: SLTask) {
        performFetch()
        guard let viewModel else { return }
        viewModel.refreshDatasource(fetchedResultsController: fetchedResultsController)
    }
}

class TaskListViewController: UICollectionViewController, UIGestureRecognizerDelegate {

    private let className = String(describing: TaskListViewController.self)

    private var viewModel: TaskListViewModel?

    private var coordinator: TaskListCoordinator?

    var fetchedResultsController: NSFetchedResultsController<SLTask>!

    init(viewModel: TaskListViewModel, coordinator: TaskListCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(collectionViewLayout: UICollectionViewLayout().createCollectionViewSectionHeaderLayout(
            itemSpace: .init(top: 0, leading: 5, bottom: 0, trailing: 5),
            groupSpacing: .zero))
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Settings", style: .plain, target: self, action: #selector(handleSettings))
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add", style: .plain, target: self, action: #selector(handleAddTask))
        #if DEBUG
        navigationItem.rightBarButtonItems?.append(
            UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(handleDeleteTask)))
        #endif

        guard let viewModel else {
            print("\(className): View model not initialised")
            return
        }

        #if DEBUG
        viewModel.createMultipleMockTasks()
        #endif

        configureFetchedResultsController()
        performFetch()
        viewModel.configureDatasource(view: collectionView)
        viewModel.updateSnapshot(fetchedResultsController: fetchedResultsController)

        setupSwipeToComplete()

        NotificationCenter.default.addObserver(
            self, selector: #selector(resetForNewDay),
            name: UIApplication.significantTimeChangeNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(refreshOnForeground),
            name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 0.7
        longPress.delegate = self
        collectionView.addGestureRecognizer(longPress)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        coordinator?.showWelcomeIfNeeded()
    }

    // MARK: - Today + midnight

    private func configureFetchedResultsController() {
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let startOfTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday)!

        let fetchRequest: NSFetchRequest<SLTask> = SLTask.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "taskToStatus.name IN %@",
                        [TaskStatus.Incomplete.rawValue, TaskStatus.Complete.rawValue]),
            NSPredicate(format: "createdAt >= %@ AND createdAt < %@",
                        startOfToday as NSDate, startOfTomorrow as NSDate),
        ])
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \SLTask.priority, ascending: true),
            NSSortDescriptor(keyPath: \SLTask.createdAt, ascending: true),
        ]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataStack.shared.moc!,
            sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
    }

    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch tasks: \(error)")
        }
    }

    @objc private func resetForNewDay() {
        configureFetchedResultsController()
        performFetch()
        guard let viewModel else { return }
        viewModel.refreshDatasource(fetchedResultsController: fetchedResultsController)
    }

    @objc private func refreshOnForeground() {
        performFetch()
        guard let viewModel else { return }
        viewModel.updateSnapshot(fetchedResultsController: fetchedResultsController)
    }

    // MARK: - Swipe to complete

    private func setupSwipeToComplete() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeComplete(_:)))
        swipe.direction = .right
        swipe.delegate = self
        collectionView.addGestureRecognizer(swipe)
    }

    @objc private func handleSwipeComplete(_ gesture: UISwipeGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: location),
              let item = viewModel?.item(at: indexPath),
              case .task(let task) = item,
              task.taskToStatus?.name == TaskStatus.Incomplete.rawValue
        else { return }

        viewModel?.completeTask(task)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    // MARK: - Actions

    @objc private func handleSettings() {
        coordinator?.presentSettings()
    }

    @objc private func handleAddTask() {
        guard let viewModel else { return }
        if viewModel.canAddTask() {
            coordinator?.presentAddGoal()
        } else {
            let alert = UIAlertController(
                title: "Goals set for today",
                message: "You've set all 3 goals for today. Complete one first to add another.",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    @objc private func handleLongPress() { }

    #if DEBUG
    @objc private func handleDeleteTask() {
        guard let viewModel else { return }
        viewModel.deleteAllTasks()
        do {
            fetchedResultsController.managedObjectContext.refreshAllObjects()
            try fetchedResultsController.performFetch()
        } catch {
            print("delete fetch err: \(error)")
        }
        viewModel.updateSnapshot(fetchedResultsController: fetchedResultsController)
    }
    #endif

    // MARK: - Collection View

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = viewModel?.item(at: indexPath) else { return }
        switch item {
        case .task(let task):
            coordinator?.presentTaskDetails(item: task)
        case .placeholder:
            guard viewModel?.canAddTask() == true else { return }
            coordinator?.presentAddGoal()
        }
    }

    deinit {
        viewModel = nil
        coordinator = nil
        NotificationCenter.default.removeObserver(self)
    }
}

extension TaskListViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let viewModel else { return }
        viewModel.applySnapshot(fetchedResultsController: fetchedResultsController)
    }
}

extension TaskListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UICollectionViewFlowLayout.automaticSize
    }
}
