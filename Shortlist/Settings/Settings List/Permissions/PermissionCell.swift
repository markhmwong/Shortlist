//
//  PermissionCell.swift
//  Shortlist
//
//  Created by Mark Wong on 12/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

// These two extensions must be individually classified for each cell. You'll also find these extensions at WhatsNewCell and PermissionsCell
// Declare an extension on the cell state struct to provide a typed property for this custom state.
private extension UICellConfigurationState {
	var permissionItem: PermissionItem? {
		set { self[.permissionItem] = newValue }
		get { return self[.permissionItem] as? PermissionItem }
	}
}

fileprivate extension UIConfigurationStateCustomKey {
	static let permissionItem = UIConfigurationStateCustomKey("com.whizbang.state.permission")
}

class PermissionsCell: BaseListCell<PermissionItem> {
	
	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.permissionItem = self.item
		return state
	}
	
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
	
	private func setupViewsIfNeeded() {
		guard viewConstraintCheck == nil else { return }
		listContentView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(listContentView)
		
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
		content.imageProperties.preferredSymbolConfiguration = .init(font: content.textProperties.font, scale: .large)
		content.text = "\(state.permissionItem?.title ?? "Unknown")"
		content.secondaryText = "\(state.permissionItem?.description ?? "Unknown")"
		content.image = UIImage(systemName: state.permissionItem?.image ?? "bandage.fill")
		listContentView.configuration = content

		let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill")?.withRenderingMode(.alwaysTemplate))
		imageView.tintColor = .systemGreen
		let customAccessory = UICellAccessory.CustomViewConfiguration(
		  customView: imageView,
		  placement: .trailing(displayed: .always))
		accessories = [.customView(configuration: customAccessory)]
	}
}
