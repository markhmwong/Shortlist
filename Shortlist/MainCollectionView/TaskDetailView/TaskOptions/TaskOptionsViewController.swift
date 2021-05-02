//
//  TaskOptionsViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 19/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

// A collection view of List type
class TaskOptionsViewController: UIViewController {

	enum CollectionListConstants: String {
		case header = "Shortlist.collectionList.header"
		case footer = "Shortlist.collectionList.footer"
	}
	
	private lazy var tableView: BaseCollectionView = {
		let view = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().createListLayout())
		view.translatesAutoresizingMaskIntoConstraints = false
		view.delegate = self
		view.backgroundColor = .black
		return view
	}()
		
	private var viewModel: TaskOptionsViewModel
	
	private var coordinator: TaskOptionsCoordinator
	
	init(viewModel: TaskOptionsViewModel, coordinator: TaskOptionsCoordinator) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .offWhite
		createTableView()
	}
	
	private func createTableView() {
		view.addSubview(tableView)
		
		tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		
		viewModel.configureDataSource(collectionView: tableView)
	}

	private func createLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

			let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
			
			let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)

			let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44.0))

			let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: CollectionListConstants.header.rawValue, alignment: .top)

			let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: CollectionListConstants.footer.rawValue, alignment: .bottom)

			section.boundarySupplementaryItems = [header, footer]

			return section
		}
		return layout
	}
}

extension TaskOptionsViewController: UICollectionViewDelegate {
	
	// MARK: - Did Select
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		if let section = TaskOptionsSection(rawValue: indexPath.section) {
			
			switch section {
                case .notes:
                    let cell = collectionView.cellForItem(at: indexPath) as! TaskOptionsCell
                    let item = cell.item
                    if item?.title == "Add a Note" {
                        coordinator.showNotes(task: viewModel.data, note: nil, persistentContainer: viewModel.persistentContainer)
                    } else {
                        //to do this is supposed to be in its' own section - to be fixed!
                        let note = viewModel.data.taskToNotes?.array[indexPath.row] as! TaskNote
                        coordinator.showNotes(task: viewModel.data, note: note, persistentContainer: viewModel.persistentContainer)
                    }
				case .content:
                    // probably get the cell
                    let cell = collectionView.cellForItem(at: indexPath) as! TaskOptionsCell
                    let type = cell.configurationState.taskOptionsItem?.type
                    
                    switch type {
                        case .name:
                            coordinator.showName(data: viewModel.data, persistentContainer: viewModel.persistentContainer)

                        case .alarm:
                            coordinator.showAlarm(data: viewModel.data, persistentContainer: viewModel.persistentContainer)

                        case .note:
                            ()
//                            let cell = collectionView.cellForItem(at: indexPath) as! TaskOptionsCell
//                            let item = cell.item
//                            if item?.title == "Add a Note" {
//                                coordinator.showNotes(task: viewModel.data, note: nil, persistentContainer: viewModel.persistentContainer)
//                            } else {
//                                //to do this is supposed to be in its' own section - to be fixed!
//                                let note = viewModel.data.taskToNotes?.array[indexPath.row - 1] as! TaskNote
//                                coordinator.showNotes(task: viewModel.data, note: note, persistentContainer: viewModel.persistentContainer)
//                                print("display existing note")
//                            }
                        case .photo:
                            ()
                            // to do
                        case .priority:
                            coordinator.showPriority(data: viewModel.data, persistentContainer: viewModel.persistentContainer)
                        case .redact:
                            coordinator.showRedactStyle(data: viewModel.data, persistentContainer: viewModel.persistentContainer)

                        case .none, .some(.delete):
                            ()
                    }
					
				case .data:
					if indexPath.item == TaskOptionsSection.DataSection.delete.rawValue {
						// add additional confirmation
						// ui action sheet / drawer from bottom
					}
            }
		}
	}
}


