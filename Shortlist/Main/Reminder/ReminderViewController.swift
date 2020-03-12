//
//  ReminderViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 12/3/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

// Reminder viewer. Allows users to pull and add reminders from the Reminder App
// A read-only Reminder view

import EventKit
import UIKit

struct ReminderViewModel {
	
}

class ReminderViewController: UIViewController {
	
	var viewModel: ReminderViewModel
	
	init(viewModel: ReminderViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
	}
	
	func setupView() {
		// ask for persmission
	}
}
