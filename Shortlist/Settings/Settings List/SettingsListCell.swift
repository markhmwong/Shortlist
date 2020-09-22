//
//  SettingsListCell.swift
//  Shortlist
//
//  Created by Mark Wong on 6/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

//class SettingsListCell: UICollectionViewListCell {
//
//	var item: SettingsListItem?
//
//}

// MARK: - Extension
// These two extensions must be individually classified for each cell. You'll also find these extensions at WhatsNewCell and PermissionsCell
// Declare an extension on the cell state struct to provide a typed property for this custom state.
private extension UICellConfigurationState {
	var settingsListItem: SettingsListItem? {
		set { self[.item] = newValue }
		get { return self[.item] as? SettingsListItem }
	}
}

fileprivate extension UIConfigurationStateCustomKey {
	static let item = UIConfigurationStateCustomKey("com.whizbang.state.whatsnew")
}

// MARK: - Cell
class SettingsListCell: BaseListCell<SettingsListItem> {
	
	private func defaultListContentConfiguration() -> UIListContentConfiguration {
		return .sidebarHeader()
	}
	
	private var viewConstraintCheck: NSLayoutConstraint? = nil
	
	private lazy var listContentView = UIListContentView(configuration: defaultListContentConfiguration())
	
	private lazy var titleLabel: BaseLabel = {
		let label = BaseLabel()
		label.textAlignment = .center
		label.font = UIFont.preferredFont(forTextStyle: .headline).with(weight: .bold)
		return label
	}()
	
	private lazy var descriptionLabel: BaseLabel = {
		let label = BaseLabel()
		label.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .regular)
		return label
	}()
	
	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.settingsListItem = self.item
		return state
	}
	
	private func setupViewsIfNeeded() {
		guard viewConstraintCheck == nil else { return }
		contentView.addSubview(listContentView)
		
		listContentView.translatesAutoresizingMaskIntoConstraints = false
		listContentView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		let bottomConstraint = listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		bottomConstraint.isActive = true
		listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
		listContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
		
		viewConstraintCheck = bottomConstraint
	}
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		setupViewsIfNeeded()

		var content = defaultListContentConfiguration().updated(for: state)
		content.text = "\(state.settingsListItem?.title ?? "Unknown")"
		content.textProperties.font = ThemeV2.CellProperties.PrimaryFont
		content.secondaryText = "\(state.settingsListItem?.subtitle ?? "Unknown")" // add task options description
		content.secondaryTextProperties.font = ThemeV2.CellProperties.SecondaryFont

		content.image = UIImage(systemName: state.settingsListItem?.icon ?? "bandage.fill")
		
		if state.settingsListItem?.subtitle != nil {
			content.secondaryText = state.settingsListItem?.subtitle
		}

		if state.settingsListItem?.disclosure == true {
			accessories = [.disclosureIndicator()]
		}

		if state.settingsListItem?.switchToggle == true {
			let toggle = UISwitch()
			let customAccessory = UICellAccessory.CustomViewConfiguration(customView: toggle, placement: .trailing(displayed: .always))
			accessories = [.customView(configuration: customAccessory)]
		}

		// highlight the tip button
		if state.settingsListItem?.item == .tip {
			content.imageProperties.tintColor = .systemOrange
			let imageView = UIImageView(image: UIImage(systemName: "chevron.right.circle.fill"))
			let customAccessory = UICellAccessory.CustomViewConfiguration(customView: imageView, placement: .trailing(displayed: .always), tintColor: content.imageProperties.tintColor, maintainsFixedSize: true)
			accessories = [.customView(configuration: customAccessory)]
		}

		if state.settingsListItem?.section == .data {
			content.textProperties.color = .systemRed
			content.imageProperties.tintColor = content.textProperties.color
		}
		
		if let section = state.settingsListItem?.item {
			switch section {
				case .taskReview:
					content.imageProperties.tintColor = .systemBlue
				case .appBiography:
					content.imageProperties.tintColor = .systemGreen
				case .clearAllCategories, .clearAllData:
					() // already set above
				case .contact:
					content.imageProperties.tintColor = .systemYellow
				case .permissions:
					content.imageProperties.tintColor = .systemTeal
				case .priorityLimit:
					content.imageProperties.tintColor = .systemPink
				case .privacy:
					()
				case .review:
					content.imageProperties.tintColor = .systemPink
				case .stats:
					content.imageProperties.tintColor = .systemIndigo
				case .tip:
					() // already set above
				case .twitter:
					content.imageProperties.tintColor = .systemPurple
				case .whatsNew:
					content.imageProperties.tintColor = .systemBlue
			}
		}

		listContentView.configuration = content
	}
}
