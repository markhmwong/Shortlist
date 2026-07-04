//
//  AddGoalViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 4/7/2026.
//  Copyright © 2026 Mark Wong. All rights reserved.
//

import UIKit

final class AddGoalViewController: UIViewController {

    var onSave: ((String, TaskPriorityLevel, Date?) -> Void)?

    private let nameField: UITextField = {
        let f = UITextField()
        f.translatesAutoresizingMaskIntoConstraints = false
        f.placeholder = "Name your goal..."
        f.font = .preferredFont(forTextStyle: .title3)
        f.autocapitalizationType = .sentences
        f.returnKeyType = .done
        f.clearButtonMode = .whileEditing
        return f
    }()

    private let priorityLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "PRIORITY"
        l.font = .preferredFont(forTextStyle: .caption1)
        l.textColor = .secondaryLabel
        return l
    }()

    private let priorityControl: UISegmentedControl = {
        let titles = TaskPriorityLevel.allCases.map { "\($0)".capitalized }
        let ctrl = UISegmentedControl(items: titles)
        ctrl.translatesAutoresizingMaskIntoConstraints = false
        ctrl.selectedSegmentIndex = 1 // default: high
        return ctrl
    }()

    // MARK: - Reminder

    private let reminderLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "REMINDER"
        l.font = .preferredFont(forTextStyle: .caption1)
        l.textColor = .secondaryLabel
        return l
    }()

    private let reminderRow: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let reminderToggleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Set reminder"
        l.font = .preferredFont(forTextStyle: .body)
        return l
    }()

    private let reminderSwitch: UISwitch = {
        let s = UISwitch()
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    private let reminderPicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.datePickerMode = .dateAndTime
        dp.preferredDatePickerStyle = .compact
        dp.minimumDate = Date()
        // Default: next round hour
        let cal = Calendar.current
        let next = cal.nextDate(after: Date(), matching: DateComponents(minute: 0), matchingPolicy: .nextTime)!
        dp.date = next
        dp.isHidden = true
        dp.alpha = 0
        return dp
    }()

    private let separator: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .separator
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Goal"
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: self, action: #selector(save))
        nameField.delegate = self
        reminderSwitch.addTarget(self, action: #selector(reminderToggled), for: .valueChanged)

        [reminderToggleLabel, reminderSwitch].forEach { reminderRow.addSubview($0) }
        [nameField, separator, priorityLabel, priorityControl,
         reminderLabel, reminderRow, reminderPicker].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameField.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            nameField.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),

            separator.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 8),
            separator.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),

            priorityLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 24),
            priorityLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),

            priorityControl.topAnchor.constraint(equalTo: priorityLabel.bottomAnchor, constant: 8),
            priorityControl.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            priorityControl.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),

            reminderLabel.topAnchor.constraint(equalTo: priorityControl.bottomAnchor, constant: 28),
            reminderLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),

            reminderRow.topAnchor.constraint(equalTo: reminderLabel.bottomAnchor, constant: 8),
            reminderRow.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            reminderRow.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            reminderRow.heightAnchor.constraint(equalToConstant: 44),

            reminderToggleLabel.centerYAnchor.constraint(equalTo: reminderRow.centerYAnchor),
            reminderToggleLabel.leadingAnchor.constraint(equalTo: reminderRow.leadingAnchor),

            reminderSwitch.centerYAnchor.constraint(equalTo: reminderRow.centerYAnchor),
            reminderSwitch.trailingAnchor.constraint(equalTo: reminderRow.trailingAnchor),

            reminderPicker.topAnchor.constraint(equalTo: reminderRow.bottomAnchor, constant: 8),
            reminderPicker.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameField.becomeFirstResponder()
    }

    @objc private func reminderToggled() {
        let show = reminderSwitch.isOn
        UIView.animate(withDuration: 0.2) {
            self.reminderPicker.isHidden = !show
            self.reminderPicker.alpha = show ? 1 : 0
        }
    }

    @objc private func save() {
        let name = nameField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        guard !name.isEmpty else { return }
        let priority = TaskPriorityLevel.allCases[priorityControl.selectedSegmentIndex]
        let reminder: Date? = reminderSwitch.isOn ? reminderPicker.date : nil
        onSave?(name, priority, reminder)
        dismiss(animated: true)
    }

    @objc private func cancel() {
        dismiss(animated: true)
    }
}

extension AddGoalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        save()
        return true
    }
}
