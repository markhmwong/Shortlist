//  TaskDetailsViewModel.swift
//  Shortlist
//
//  Created by Mark on 10/5/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import CoreData
import UIKit

struct TaskDetailCellContentViewModel {
    let titleText: String?
    let valueText: String?
    let image: UIImage?
    let style: CellStyle
    
    enum CellStyle {
        case cell, subtitle, value1
    }
    
    func contentConfiguration() -> UIListContentConfiguration {
        var config: UIListContentConfiguration
        switch style {
        case .cell:
				config = UIListContentConfiguration.cell()
        case .subtitle:
            config = UIListContentConfiguration.subtitleCell()
        case .value1:
				config = UIListContentConfiguration.valueCell()
        }
        config.text = titleText
        config.secondaryText = valueText
        config.image = image
        return config
    }
}

class TaskDetailsViewModel: NSObject, TextFieldTableViewCellDelegate, TextViewTableViewCellDelegate {

	private typealias Item = AnyTaskDetailItem

	public enum Section: Int, CaseIterable {
		case name
		case description
		case priority
		case reminder
		case category
		case photo
		case destination

        var headerTitle: String {
            switch self {
            case .name: return "Name"
            case .description: return "Description"
            case .priority: return "Priority"
            case .reminder: return "Reminder"
            case .category: return "Category"
            case .photo: return "Photo"
            case .destination: return "Destination"
            }
        }

        /// Use Section enum directly as identifier for header titles with diffable data source.
        static func headerTitle(for section: Section) -> String {
            section.headerTitle
        }
	}

	public let task: Binding<SLTask>

	private let coreData: CoreDataStack

	private var dataSource: UITableViewDiffableDataSource<Section, AnyTaskDetailItem>!

	public let sections: [Section] = Section.allCases

	init(item: SLTask, coreData: CoreDataStack) {
		self.coreData = coreData
		self.task = Binding(value: item)
		super.init()
		
	}

	//MARK: Tableview Diffable Datasource
	public func configureDiffableDataSource(with tableViewController: UITableViewController) {
		dataSource = UITableViewDiffableDataSource<Section, AnyTaskDetailItem>(tableView: tableViewController.tableView) { [weak self] tableView, indexPath, item in
			guard let self = self else { return nil }
			let task = self.task.value

			switch indexPath.section {
				case Section.name.rawValue:
					let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
					let value = (item.value?.stringValue ?? "").localizedCapitalized
					let title = item.title.localizedCapitalized
					cell.configure(placeholder: "Name", text: value, title: title)
					cell.delegate = self
					return cell
				case Section.description.rawValue:
					let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier, for: indexPath) as! TextViewTableViewCell
					let title = item.title.localizedCapitalized
					let value = (item.value?.stringValue ?? "").localizedLowercase
					cell.configure(title: title, text: value, tableView: tableViewController.tableView)
					cell.delegate = self
					return cell
				case Section.priority.rawValue:
					let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.identifier, for: indexPath) as! SelectableTableViewCell
					let title = item.title//TaskPriorityLevel(rawValue: Int(task.priority)) ?? TaskPriorityLevel.low
					let value = item.value?.stringValue ?? "\(task.priority)"
					let viewModel = TaskDetailCellContentViewModel(
						titleText: title.capitalized,
						valueText: value,
						image: nil,
						style: .value1
					)
					cell.configure(viewModel: viewModel)
					return cell
				case Section.reminder.rawValue:
					let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.identifier, for: indexPath) as! SelectableTableViewCell
					let title = item.title
					let value = item.value?.dateValue?.formattedWithTime() ?? "No Reminder"
					let viewModel = TaskDetailCellContentViewModel(
						titleText: title,
						valueText: value,
						image: nil,
						style: .value1
					)
					cell.contentConfiguration = viewModel.contentConfiguration()
					return cell
				case Section.category.rawValue:
					let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.identifier, for: indexPath) as! SelectableTableViewCell
					let title = item.title
					let value = item.value?.stringValue ?? "General"
					let viewModel = TaskDetailCellContentViewModel(
						titleText: title,
						valueText: value,
						image: nil,
						style: .value1
					)
					cell.contentConfiguration = viewModel.contentConfiguration()
					return cell
				case Section.photo.rawValue:
					let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.identifier, for: indexPath) as! SelectableTableViewCell
					var thumbnail: UIImage?
					if let filename = task.media, !filename.isEmpty {
						thumbnail = MediaManager.loadImage(filename: filename).map { MediaManager.thumbnail(from: $0) }
					}
					let viewModel = TaskDetailCellContentViewModel(
						titleText: thumbnail != nil ? "Photo attached" : "Add Photo",
						valueText: nil,
						image: thumbnail ?? UIImage(systemName: "camera"),
						style: .cell
					)
					cell.contentConfiguration = viewModel.contentConfiguration()
					return cell
				case Section.destination.rawValue:
					let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.identifier, for: indexPath) as! SelectableTableViewCell
					let hasLocation = task.lat != 0 || task.long != 0
					let locationText = hasLocation ? (task.placeName ?? "Location set") : "Set Destination"
					let viewModel = TaskDetailCellContentViewModel(
						titleText: locationText,
						valueText: nil,
						image: UIImage(systemName: hasLocation ? "mappin.circle.fill" : "mappin.circle"),
						style: .cell
					)
					cell.contentConfiguration = viewModel.contentConfiguration()
					return cell
				default:
					let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.identifier, for: indexPath) as! SelectableTableViewCell
					cell.contentConfiguration = UIListContentConfiguration.cell()
					return cell
			}
		}
	}

	private func createItems() -> [AnyTaskDetailItem] {
		let nameItem = WritableTaskDetail(title: "Name", value: .string(task.value.name ?? ""), section: .name)
		let	descripionItem = WritableContentTaskDetail(title: "Description", value: .string(task.value.taskDescription ?? ""), section: .description)
		let priorityItem = SelectableTaskDetail(title: "Priority", value: .string("\(task.value.priority)"), section: .priority)
		let reminderItem = SelectableTaskDetail(title: "Reminder", value: .date(task.value.reminder ?? Date()), section: .reminder)

		let category = AssetManager.Category(rawValue: task.value.taskToCategory?.type ?? 0)
		let categoryItem = SelectableTaskDetail(
			title: "Category",
			value: .string(category?.name ?? AssetManager.Category.general.name),
			section: .category
		)
		let photoItem = SelectableTaskDetail(title: "Photo", value: .string(task.value.media ?? ""), section: .photo)
		let destinationItem = SelectableTaskDetail(title: "Destination", value: .string(task.value.placeName ?? ""), section: .destination)

		return [
			AnyTaskDetailItem(nameItem),
			AnyTaskDetailItem(descripionItem),
			AnyTaskDetailItem(priorityItem),
			AnyTaskDetailItem(reminderItem),
			AnyTaskDetailItem(categoryItem),
			AnyTaskDetailItem(photoItem),
			AnyTaskDetailItem(destinationItem),
		]
	}

	public func attachPhoto(_ image: UIImage) {
		guard let id = task.value.id else { return }
		if let oldFilename = task.value.media, !oldFilename.isEmpty {
			MediaManager.deleteImage(filename: oldFilename)
		}
		let filename = MediaManager.saveImage(image, for: id)
		task.value.media = filename
		coreData.saveContext()
	}

	public func clearPhoto() {
		if let filename = task.value.media, !filename.isEmpty {
			MediaManager.deleteImage(filename: filename)
		}
		task.value.media = nil
		coreData.saveContext()
	}

	public func setDestination(lat: Double, long: Double, placeName: String?) {
		task.value.lat = lat
		task.value.long = long
		task.value.placeName = placeName
		coreData.saveContext()
		NotificationService.shared.scheduleGeofenceArrival(for: task.value)
	}

	public func clearDestination() {
		NotificationService.shared.cancelGeofenceArrival(for: task.value)
		task.value.lat = 0
		task.value.long = 0
		task.value.placeName = nil
		coreData.saveContext()
	}

	public func applySnapshot() {
		var snapshot = NSDiffableDataSourceSnapshot<Section, AnyTaskDetailItem>()
		snapshot.appendSections(Section.allCases)

		let allItems = createItems()

		for item in allItems {
			snapshot.appendItems([item], toSection: item.section)
		}
		dataSource.defaultRowAnimation = .fade
		dataSource.apply(snapshot, animatingDifferences: true)
	}

	//MARK: Task methods
	func taskIsComplete(completionHandler: (SLTask) -> ()) {
		// handle data
		let status = TaskStatus(rawValue: task.value.taskToStatus?.name ?? "Incomplete")

		switch status {
			case .Complete:
				task.value.taskToStatus?.name = TaskStatus.Incomplete.rawValue
			case .Incomplete:
				task.value.taskToStatus?.name = TaskStatus.Complete.rawValue
			case .Backlog:
				()
			case .none, .Active:
				()
		}

		// save object state
		coreData.saveContext()

		// handle view dismissal and animations
		completionHandler(task.value)
	}

	public func save(
		priority: Int16,
		longitude: Double = 0.0,
		latitude: Double = 0.0
	) {
//		task.value.name = title
//		task.value.taskDescription = description
		task.value.priority = priority
		task.value.long = longitude
		task.value.lat = latitude

		// save object state
		coreData.saveContext()
	}

	public func updateName(_ name: String) {
		task.value.name = name
		coreData.saveContext()
	}

	public func updateDescription(_ description: String) {
		task.value.taskDescription = description
		coreData.saveContext()
	}

	// MARK: - TextFieldTableViewCellDelegate

	public func textFieldCell(_ cell: TextFieldTableViewCell, didUpdateText text: String) {
		updateName(text)
	}

	// MARK: - TextViewTableViewCellDelegate

	public func textViewCell(_ cell: TextViewTableViewCell, didUpdateText text: String) {
		updateDescription(text)
	}

}

