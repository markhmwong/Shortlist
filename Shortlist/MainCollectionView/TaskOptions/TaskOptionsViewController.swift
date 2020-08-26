//
//  TaskOptionsViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 19/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class TaskOptionsViewController: UIViewController {

	enum CollectionListConstants: String {
		case header = "Shortlist.collectionList.header"
		case footer = "Shortlist.collectionList.footer"
	}
	
	private lazy var tableView: BaseCollectionView = {
		let view = BaseCollectionView(frame: .zero, collectionViewLayout: createLayout())
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
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		if let section = TaskOptionsSection(rawValue: indexPath.section) {
			
			switch section {
				case .content:
					if indexPath.item == TaskOptionsSection.ContentSection.name.rawValue {
						coordinator.showName()
					} else if indexPath.item == TaskOptionsSection.ContentSection.notes.rawValue {
						coordinator.showNotes()
					}
				case .data:
					if indexPath.item == TaskOptionsSection.DataSection.delete.rawValue {
						
					}
				case .redact:
					if indexPath.item == TaskOptionsSection.ConcealSection.redact.rawValue {
						
					}
				case .reminder:
					if indexPath.item == TaskOptionsSection.ReminderSection.alarm.rawValue {
						coordinator.showAlarm()
					} else if indexPath.item == TaskOptionsSection.ReminderSection.allday.rawValue {
						
					}
			}
		}
	}
}


