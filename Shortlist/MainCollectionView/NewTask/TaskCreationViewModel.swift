//
//  NewTaskViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 29/11/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

/*

	MARK: - New Task View Model

	One view model passed between the new task guide

*/

class TaskCreationViewModel: NSObject {
	
	var persistentContainer: PersistentContainer
	
	var keyboardSize: CGRect = .zero

	var task: Task
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<TaskCreationNotesSection, TaskCreationNotesItem>! = nil
	
	init(persistentContainer: PersistentContainer) {
		self.persistentContainer = persistentContainer
		self.task = Task(context: persistentContainer.viewContext)
		super.init()
	}
	
	func createTask() {
		if let day = persistentContainer.fetchDayEntity(forDate: Calendar.current.today()) as? Day {
			task.create(context: persistentContainer.viewContext, taskName: "", categoryName: "", createdAt: Date(), reminderDate: Date(), priority: 0, redact: 0)
			day.addTask(with: task)
			
			persistentContainer.saveContext()
		}
	}
	
	func assignTitle(taskName: String) {
		task.name = taskName
	}
	
	func assignPriority(priority: Int16) {
		task.priority = priority
	}
}

enum TaskCreationNotesSection: Int, CaseIterable {
	case main
}

struct TaskCreationNotesItem: Hashable {
	var id: UUID = UUID()
	var description: String
	var date: Date = Date()
}

extension TaskCreationViewModel {
	/******
		CollectionView methods required for Notes View Controller
	********/

	// MARK: - Diffable Datasource
	private func configureSnapshot() {
		guard let diffableDataSource = diffableDataSource else { return }
		
		var snapshot = NSDiffableDataSourceSnapshot<TaskCreationNotesSection, TaskCreationNotesItem>()
		snapshot.appendSections(TaskCreationNotesSection.allCases)
		
		let data = prepareDataSource()
		
		for d in data {
			snapshot.appendItems([d], toSection: TaskCreationNotesSection.main)
		}

		// BUG: using this apply method refreshes the collectionview twice. however using the method with the animating differences won't allow for dynamic heights
		diffableDataSource.apply(snapshot, animatingDifferences: false) { }
	}
	
	// MARK: - Prep data
	private func prepareDataSource() -> [TaskCreationNotesItem] {
		var taskOptionsItems: [TaskCreationNotesItem] = []
		
		let itemOne = TaskCreationNotesItem(id: UUID(), description: "Test One", date: Date())
		taskOptionsItems.append(itemOne)
		return taskOptionsItems
	}
	
	// viewcontroller entry begins here
	func configureDataSource(collectionView: UICollectionView) {
		
		diffableDataSource = UICollectionViewDiffableDataSource<TaskCreationNotesSection, TaskCreationNotesItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewListCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellRegistration(), for: indexPath, item: item)
			return cell
		}
		
		configureSnapshot()
	}
	
	// MARK: - Register Cell
	private func configureCellRegistration() -> UICollectionView.CellRegistration<TaskCreationNotesListCell, TaskCreationNotesItem> {
		let cellConfig = UICollectionView.CellRegistration<TaskCreationNotesListCell, TaskCreationNotesItem> { (cell, indexPath, item) in
			// setup cell views and text from item
			cell.configureCell(with: item)
		}
		return cellConfig
	}
}

private extension UICellConfigurationState {
	var taskCreationOptionsItem: TaskCreationNotesItem? {
		set { self[.item] = newValue }
		get { return self[.item] as? TaskCreationNotesItem }
	}
}

fileprivate extension UIConfigurationStateCustomKey {
	static let item = UIConfigurationStateCustomKey("com.whizbang.state.taskCreationNotes")
}

class TaskCreationNotesListCell: BaseListCell<TaskCreationNotesItem>, UITextViewDelegate {
	
	lazy var textView: UITextView = {
		let view = UITextView()
		view.isEditable = true
		view.delegate = self
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.taskCreationOptionsItem = self.item
		return state
	}
	
	private func defaultListContentConfiguration() -> UIListContentConfiguration {
		return .sidebarHeader()
	}
	
	private var viewConstraintCheck: NSLayoutConstraint? = nil

	private lazy var listContentView = UIListContentView(configuration: defaultListContentConfiguration())
	
	private func setupViewsIfNeeded() {
		guard viewConstraintCheck == nil else { return }
		contentView.addSubview(listContentView)
		listContentView.translatesAutoresizingMaskIntoConstraints = false
		
		listContentView.addSubview(textView)
		textView.topAnchor.constraint(equalTo: listContentView.topAnchor, constant: 0).isActive = true
		textView.leadingAnchor.constraint(equalTo: listContentView.leadingAnchor, constant: 0).isActive = true
		textView.trailingAnchor.constraint(equalTo: listContentView.trailingAnchor, constant: 0).isActive = true
		textView.bottomAnchor.constraint(equalTo: listContentView.bottomAnchor, constant: 0).isActive = true
		
		listContentView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		let bottomConstraint = listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		bottomConstraint.isActive = true
		listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
		listContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
		
		viewConstraintCheck = bottomConstraint
	}
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		setupViewsIfNeeded()
		var content: UIListContentConfiguration = defaultListContentConfiguration().updated(for: state)
		textView.text = "\(state.taskCreationOptionsItem?.description ?? "Unknown")"
//		content.text = "\(state.taskCreationOptionsItem?.description ?? "Unknown")"
//		content.textProperties.font = UIFont.preferredFont(forTextStyle: .body)
		listContentView.configuration = content
		
	}
}
