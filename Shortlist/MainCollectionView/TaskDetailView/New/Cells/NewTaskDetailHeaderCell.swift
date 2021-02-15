//
//  NewTaskHeaderCell.swift
//  Shortlist
//
//  Created by Mark Wong on 26/1/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit

extension UICellConfigurationState {
	var newTaskDetailHeaderItem: NewTaskDetailHeaderItem? {
		set { self[.newTaskHeaderItem] = newValue }
		get { return self[.newTaskHeaderItem] as? NewTaskDetailHeaderItem }
	}
}

fileprivate extension UIConfigurationStateCustomKey {
	static let newTaskHeaderItem = UIConfigurationStateCustomKey("com.whizbang.cell.newTask.header")
}

class NewTaskDetailHeaderCell: BaseCell<NewTaskDetailHeaderItem> {
	
	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.newTaskDetailHeaderItem = self.item
		return state
	}
	
	lazy var redact: UIImageView = {
		let config = UIImage.SymbolConfiguration(pointSize: UIFont.systemFontSize)
		let image = UIImage(systemName: "eye.slash", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
		let view = UIImageView(image: image)
		view.tintColor = UIColor.offBlack
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	lazy var priority: UIImageView = {
		let config = UIImage.SymbolConfiguration(font: UIFont.preferredFont(forTextStyle: .largeTitle))
		let image = UIImage(systemName: "exclamationmark.bubble.fill", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
		let view = UIImageView(image: image)
		view.tintColor = UIColor.offBlack
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	lazy var reminder: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "0:00"
		label.font = UIFont.preferredFont(forTextStyle: .subheadline).with(weight: .regular)
		label.textColor = UIColor.offBlack
		return label
	}()
	
	lazy var header: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "High"
		label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
		label.textColor = UIColor.offBlack
		return label
	}()
	
	private var viewConstraintCheck: NSLayoutConstraint? = nil
	
	private func setupViewsIfNeeded() {
		guard viewConstraintCheck == nil else { return }
		let bg = UIView()
		bg.backgroundColor = UIColor.offWhite
		backgroundView = bg
		contentView.backgroundColor = UIColor.offWhite
		backgroundColor = UIColor.offWhite
		let longPadding: CGFloat = 30.0
		contentView.addSubview(header)
		contentView.addSubview(reminder)
		contentView.addSubview(redact)
		contentView.addSubview(priority)

		
		priority.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
		viewConstraintCheck = priority.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0)
		viewConstraintCheck?.isActive = true
		
		header.leadingAnchor.constraint(equalTo: priority.trailingAnchor, constant: 10).isActive = true
		header.bottomAnchor.constraint(equalTo: priority.bottomAnchor).isActive = true

		
//		header.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -longPadding).isActive = true
//		contentView.bottomAnchor.constraint(equalTo: header.topAnchor, constant: longPadding).isActive = true
//		header.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -longPadding).isActive = true
		
		redact.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0).isActive = true
		redact.bottomAnchor.constraint(equalTo: reminder.topAnchor, constant: 0).isActive = true
		
		reminder.bottomAnchor.constraint(equalTo: priority.bottomAnchor, constant: 0).isActive = true
		reminder.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true

	}
	
	func animatePriority() {
//		self.contentView.layoutIfNeeded()
		UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseInOut) {
			self.priority.transform = CGAffineTransform.init(translationX: 0.0, y: -50.0)
			self.contentView.layoutIfNeeded()
		} completion: { (state) in
			
		}
	}
	
	
	func setGradientBackground() -> CAGradientLayer {
		let colorTop =  UIColor.systemPink.adjust(by: -20)!.cgColor
		let colorBottom = UIColor.systemPink.adjust(by: 5)!.cgColor
					
		let gradientLayer = CAGradientLayer()
		gradientLayer.colors = [colorTop, colorBottom]
		gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
		gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
		gradientLayer.frame = self.bounds
		return gradientLayer
	}
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		setupViewsIfNeeded()
		
		header.text = state.newTaskDetailHeaderItem?.priority
		reminder.text = state.newTaskDetailHeaderItem?.reminder
		

	}
}
