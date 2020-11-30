//
//  TaskCreationRemidnerViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 28/11/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class TaskCreationReminderViewController: UIViewController {
	
	private var viewModel: TaskCreationViewModel
	
	private var coordinator: NewTaskCoordinator
	
	// all day
	// from time
	
	var dateChange: ((Date) -> ())? = nil

	lazy var calendarView: UIDatePicker = {
		let view = UIDatePicker()
		view.preferredDatePickerStyle = .compact
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		view.datePickerMode = .time
		view.contentHorizontalAlignment = .trailing
		view.addTarget(self, action: #selector(handleDatePicker), for: .editingDidEnd)
		return view
	}()
	
	init(viewModel: TaskCreationViewModel, coordinator: NewTaskCoordinator) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = ThemeV2.Background
		// date picker
		view.addSubview(calendarView)
		
		calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height * 0.25).isActive = true
		calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
//		calendarView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
//		calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
	}
	
	@objc func handleDatePicker() {
		dateChange?(calendarView.date)
	}
}
