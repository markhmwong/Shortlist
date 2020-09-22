//
//  EditTaskToggleCell.swift
//  Shortlist
//
//  Created by Mark Wong on 5/11/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class EditTaskToggleCell: CellBase {
	
	weak var viewModel: EditTaskViewModel?
	
	private lazy var toggleView: UISwitch = {
		guard let viewModel = viewModel else {
			let toggle = UISwitch()
			toggle.isOn = false
			toggle.addTarget(self, action: #selector(handleToggle), for: .touchUpInside)
			toggle.translatesAutoresizingMaskIntoConstraints = false
			return toggle
		}
		let toggle = UISwitch()
		toggle.isOn = viewModel.reminderToggle
		toggle.addTarget(self, action: #selector(handleToggle), for: .touchUpInside)
		toggle.translatesAutoresizingMaskIntoConstraints = false
		return toggle
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupCellLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func setupCellLayout() {
		super.setupCellLayout()
		let backgroundView = UIView()
		backgroundView.backgroundColor = .clear
		selectedBackgroundView = backgroundView
		backgroundColor = .clear
		textLabel?.attributedText = NSMutableAttributedString(string: "Remind me", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b1).value)!])
		
		addSubview(toggleView)
		toggleView.anchorView(top: nil, bottom: nil, leading: nil, trailing: trailingAnchor, centerY: centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -20.0), size: .zero)
	}
	
	func toggleState() -> Bool {
		return toggleView.isOn
	}
	
	@objc
	func handleToggle(_ sender: UISwitch) {
		let tableView = superview as! UITableView
		viewModel?.reminderToggle = sender.isOn
		tableView.beginUpdates()
		tableView.endUpdates()
	}
}
