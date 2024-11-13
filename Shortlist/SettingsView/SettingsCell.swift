//
//  SettingsCell.swift
//  Shortlist
//
//  Created by Mark Wong on 4/8/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit
import WhizUtilKit

class SettingsCell: BaseCollectionViewCell<SettingsItem> {
    public var _item: SettingsItem? {
        set {
            item = newValue
            titleLabel.text = item?.name
        }
        get {
            return item
        }
    }
    
    private lazy var titleLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "placeholder"
        label.font = UIFont.preferredFont(forTextStyle: .body).withWeight(.bold)
        label.textColor = .defaultText
        label.backgroundColor = .clear
        label.isEditable = false
        label.isUserInteractionEnabled = false
        label.isScrollEnabled = false
        return label
    }()

    override func setupViewsIfNeeded() {
        super.setupViewsIfNeeded()
        contentView.layer.cornerRadius = 5.0
        
        /// layout
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
        ])
    }
 
    /// Configure Cell
    /// - Parameter item: the model that is passed to fill out contents of the cell
    public override func configureCell(with item: SettingsItem) {
        super.configureCell(with: item)
        // configure item in the setter for _item
        _item = item

    }

}

class SliderSettingsCell: BaseCollectionViewCell<SettingsItem> {
	public var _item: SettingsItem? {
		set {
			item = newValue
			titleLabel.text = item?.name
		}
		get {
			return item
		}
	}

	private lazy var titleLabel: UITextView = {
		let label = UITextView()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "placeholder"
		label.font = UIFont.preferredFont(forTextStyle: .body).withWeight(.bold)
		label.textColor = .defaultText
		label.backgroundColor = .clear
		label.isEditable = false
		label.isUserInteractionEnabled = false
		label.isScrollEnabled = false
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
	public override func configureCell(with item: SettingsItem) {
		super.configureCell(with: item)
		// configure item in the setter for _item
		self._item = item
	}

	@objc public func sliderValueChanged() {
		// TODO: slider

	}
}
