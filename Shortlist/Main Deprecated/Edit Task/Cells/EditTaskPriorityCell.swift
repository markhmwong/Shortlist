//
//  EditTaskPriorityCell.swift
//  Shortlist
//
//  Created by Mark Wong on 18/12/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class EditTaskPriorityCell: CellBase {
	
	weak var viewModel: EditTaskViewModel? {
		didSet {
			guard let _viewModel = viewModel else { return }
			priority = _viewModel.priorityLevel
			fashionPriorityButton()
		}
	}
	
	var priority: Priority = .medium
	
	var priorityColor: UIColor = Theme.Priority.mediumColor
	
	// three buttons
	lazy var priorityButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		//attributed text
		button.setAttributedTitle(NSAttributedString(string: "Medium", attributes: [NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b2).value)!, NSAttributedString.Key.foregroundColor: Theme.Font.DefaultColor]), for: .normal)
		button.layer.backgroundColor = Theme.Priority.mediumColor.cgColor
		button.layer.cornerRadius = 5.0
		button.addTarget(self, action: #selector(handlePriority), for: .touchUpInside)
		return button
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		priority = .medium
		super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellLayout()
	}
	
	required init?(coder: NSCoder) {
		priority = .medium
		super.init(coder: coder)
	}
	
	override func setupCellLayout() {
		super.setupCellLayout()
		backgroundColor = .clear
		addSubview(priorityButton)
		
		priorityButton.anchorView(top: nil, bottom: nil, leading: nil, trailing: nil, centerY: centerYAnchor, centerX: centerXAnchor, padding: .zero, size: CGSize(width: bounds.width / 3.5, height: 0.0))
	}
	
	private func fashionPriorityButton() {
		guard let _viewModel = viewModel else { return }
		
		switch _viewModel.priorityLevel {
			case .medium:
				priority = .medium
				updateButton(string: "Medium", color: Theme.Priority.mediumColor)
			case .high:
				priority = .high
				updateButton(string: "High", color: Theme.Priority.highColor)
			case .low:
				priority = .low
				updateButton(string: "Low", color: Theme.Priority.lowColor)
			case .none:
				priority = .medium
				updateButton(string: "Medium", color: Theme.Priority.mediumColor)
		}
		
	}
	
	@objc func handlePriority(_ sender: Any) {
		
		switch priority {
			case .low:
				priority = .medium
				updateButton(string: "Medium", color: Theme.Priority.mediumColor)
			case .medium:
				priority = .high
				updateButton(string: "High", color: Theme.Priority.highColor)
			case .high:
				priority = .low
				updateButton(string: "Low", color: Theme.Priority.lowColor)
			case .none:
				priority = .medium
				updateButton(string: "Medium", color: Theme.Priority.mediumColor)
		}
		guard let vm = viewModel else { return }
		vm.priorityLevel = priority
	}
	
	func updateButton(string: String, color: UIColor) {
		DispatchQueue.main.async {
			self.priorityButton.layer.backgroundColor = color.cgColor
			self.priorityButton.setAttributedTitle(NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b2).value)!]), for: .normal)
		}
	}
}
