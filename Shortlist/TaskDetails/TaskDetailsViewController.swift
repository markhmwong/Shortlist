//  TaskDetailsView.swift
//  Shortlist
//
//  Created by Mark on 10/5/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit
import PhotosUI
import os

class TaskDetailsViewController: UITableViewController, RefreshablePopView {
	func refresh(item: SLTask) {
		DispatchQueue.main.async { [weak self] in
			self?.viewModel.task.value = item
			self?.viewModel.applySnapshot()
		}
	}

	private var viewModel: TaskDetailsViewModel

	/// Navigation
	private var coordinator: TaskDetailsCoordinator

	public var delegate: RefreshablePopView

	init(viewModel: TaskDetailsViewModel, coordinator: TaskDetailsCoordinator, delegate: RefreshablePopView) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		self.delegate = delegate
		super.init(style: .insetGrouped)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .secondarySystemBackground

		tableView.separatorStyle = .none
		title = "Task Details"
		tableView.tableFooterView = createCompleteButton()
		registerTableViewCells()
		viewModel.configureDiffableDataSource(with: self)
		viewModel.applySnapshot()

		// Reload table when item changes
		viewModel.task.bind { [weak self] _ in
			DispatchQueue.main.async {
				self?.viewModel.applySnapshot()
			}
		}
	}

	private func registerTableViewCells() {
		tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.identifier)
		tableView.register(TextViewTableViewCell.self, forCellReuseIdentifier: TextViewTableViewCell.identifier)
		tableView.register(SelectableTableViewCell.self, forCellReuseIdentifier: SelectableTableViewCell.identifier)
	}

	private func createCompleteButton() -> UIView {
		let button = UIButton(type: .system)
		button.setTitle("Complete", for: .normal)
		button.titleLabel?.font = .boldSystemFont(ofSize: 18)
		button.backgroundColor = .systemGray5
		button.layer.cornerRadius = 10
		button.translatesAutoresizingMaskIntoConstraints = false
		button.heightAnchor.constraint(equalToConstant: 60).isActive = true
		button.addTarget(self, action: #selector(handleComplete), for: .touchUpInside)

		let container = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 70))
		container.addSubview(button)

		NSLayoutConstraint.activate([
			button.leadingAnchor.constraint(equalTo: container.layoutMarginsGuide.leadingAnchor),
			button.trailingAnchor.constraint(equalTo: container.layoutMarginsGuide.trailingAnchor),
			button.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
			button.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
		])

		return container
	}

	@objc private func handleComplete() {

		if !validation() {
			let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.whizbang.shortlist", category: "TaskDetails")
			logger.warning("Validation failed")
			return
		}

		viewModel.taskIsComplete { [weak self] item in
			guard let self = self else { return }
			self.viewModel.save(// get the data from the text view
				priority: item.priority,
				longitude: item.long,
				latitude: item.lat
			)
			self.coordinator.dismissCurrentView()
			self.delegate.refresh(item: item)
		}
	}

	private func validation() -> Bool {
		let name = viewModel.task.value.name?.trimmingCharacters(in: .whitespacesAndNewlines)
		if name == nil || name!.isEmpty {
			presentAlert(title: "Missing Name", message: "Please enter a name for the task.")
			return false
		}
		return true
	}

	private func presentAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		present(alert, animated: true, completion: nil)
	}

	// MARK: - TableView Delegate

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let section = viewModel.sections[indexPath.section]

		switch section {
		case .priority:
			coordinator.pushPrioritySelectionViewController(with: viewModel.task.value)
		case .reminder:
			coordinator.pushReminderDatePickerViewController(with: viewModel.task.value)
		case .category:
			coordinator.pushCategorySelectionViewController(with: viewModel.task.value)
		case .photo:
			presentPhotoOptions()
		case .destination:
			coordinator.pushDestinationPickerViewController(with: viewModel.task.value, delegate: self)
		default:
			break
		}

		tableView.deselectRow(at: indexPath, animated: true)
	}

	// MARK: - Photo

	private func presentPhotoOptions() {
		let hasPhoto = !(viewModel.task.value.media?.isEmpty ?? true)
		let sheet = UIAlertController(title: "Photo", message: nil, preferredStyle: .actionSheet)
		sheet.addAction(UIAlertAction(title: "Choose Photo", style: .default) { [weak self] _ in
			self?.presentPHPicker()
		})
		if hasPhoto {
			sheet.addAction(UIAlertAction(title: "Remove Photo", style: .destructive) { [weak self] _ in
				self?.viewModel.clearPhoto()
				self?.viewModel.applySnapshot()
			})
		}
		sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(sheet, animated: true)
	}

	private func presentPHPicker() {
		var config = PHPickerConfiguration()
		config.filter = .images
		config.selectionLimit = 1
		let picker = PHPickerViewController(configuration: config)
		picker.delegate = self
		present(picker, animated: true)
	}
}

// MARK: - PHPickerViewControllerDelegate

extension TaskDetailsViewController: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		dismiss(animated: true)
		guard let result = results.first else { return }
		result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
			guard let image = object as? UIImage else { return }
			DispatchQueue.main.async {
				self?.viewModel.attachPhoto(image)
				self?.viewModel.applySnapshot()
			}
		}
	}
}

// MARK: - DestinationPickerDelegate

extension TaskDetailsViewController: DestinationPickerDelegate {
	func destinationPicker(didSelect lat: Double, long: Double, placeName: String?) {
		viewModel.setDestination(lat: lat, long: long, placeName: placeName)
		viewModel.applySnapshot()
	}
}
