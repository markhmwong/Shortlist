//
//  SliderSettingsCell.swift
//  Shortlist
//
//  Created by Mark Wong on 14/12/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit
import WhizUtilKit

class SliderSettingsCell: BaseCollectionViewCell<AnySettingsItem> {

	public var _item: AnySettingsItem? {
		set {
			item = newValue
			if let item = item, let baseItem = item.baseItem as? SettingsTaskLimitItem {
				let integerValue = Int(baseItem.value ?? "0") ?? 0
				let titleLabel = "\(item.title) \(integerValue)"
				updateTitleLabel(titleLabel)
				slider.value =  Float(integerValue)
			}
		}
		get {
			return item
		}
	}

	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "placeholder"
		label.font = UIFont.preferredFont(forTextStyle: .body).withWeight(.bold)
		label.textColor = .defaultText
		label.backgroundColor = .clear
		return label
	}()

	private lazy var slider: UISlider = {
		let slider = UISlider()
		slider.translatesAutoresizingMaskIntoConstraints = false
		slider.minimumValue = 0.0
		slider.maximumValue = 7.0
		slider.value = 3.0
		slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
		return slider
	}()

	override func setupViewsIfNeeded() {
		super.setupViewsIfNeeded()
		contentView.layer.cornerRadius = 5.0

		/// layout
		contentView.addSubview(titleLabel)
		contentView.addSubview(slider)

		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),

			slider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
			slider.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
			slider.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
			slider.bottomAnchor.constraint(equalTo: contentView.readableContentGuide.bottomAnchor),
		])
	}

	/// Configure Cell
	/// - Parameter item: the model that is passed to fill out contents of the cell
	public override func configureCell(with item: AnySettingsItem) {
		super.configureCell(with: item)
		// configure item in the setter for _item
		self._item = item
	}

	@objc public func sliderValueChanged(_ sender: UISlider) {
		let taskLimit = Int16(sender.value)
		updateTitleLabel("Task Limit \(taskLimit)")
		SettingsManager.shared.setTaskLimit(taskLimit)
	}

	private func updateTitleLabel(_ string: String) {
		titleLabel.text = string
	}
}
