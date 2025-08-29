import UIKit

final class ReminderDatePickerViewController: UIViewController {

    private let datePicker = UIDatePicker()

	private let viewModel: ReminderDatePickerViewModel

	private let coordinator: TaskDetailsCoordinator

	init(coordinator: TaskDetailsCoordinator, viewModel: ReminderDatePickerViewModel) {
		self.viewModel = viewModel
		self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .automatic
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
		setupDatePicker()
	}

    private func setupDatePicker() {
        datePicker.datePickerMode = .dateAndTime
		datePicker.preferredDatePickerStyle = .inline
        datePicker.translatesAutoresizingMaskIntoConstraints = false
		datePicker.date = viewModel.selectedDate ?? viewModel.initialDate
        view.addSubview(datePicker)

        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			datePicker.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        ])
    }

	@objc func doneButtonTapped() {
		viewModel.updateReminderDate(datePicker.date)
		coordinator.refreshOnPop(with: viewModel.task)
	}
}
