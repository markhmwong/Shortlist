//
//  AddGoalViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 4/7/2026.
//  Copyright © 2026 Mark Wong. All rights reserved.
//

import UIKit

final class AddGoalViewController: UIViewController {

    var onSave: ((String, TaskPriorityLevel) -> Void)?

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

        view.addSubview(nameField)
        view.addSubview(separator)
        view.addSubview(priorityLabel)
        view.addSubview(priorityControl)

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
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameField.becomeFirstResponder()
    }

    @objc private func save() {
        let name = nameField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        guard !name.isEmpty else { return }
        let priority = TaskPriorityLevel.allCases[priorityControl.selectedSegmentIndex]
        onSave?(name, priority)
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
