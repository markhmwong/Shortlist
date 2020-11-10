//
//  WhatsNewCell.swift
//  Shortlist
//
//  Created by Mark Wong on 9/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
// These two extensions must be individually classified for each cell. You'll also find these extensions at WhatsNewCell and PermissionsCell
// Declare an extension on the cell state struct to provide a typed property for this custom state.
private extension UICellConfigurationState {
	var item: FeatureItem? {
		set { self[.item] = newValue }
		get { return self[.item] as? FeatureItem }
	}
}

fileprivate extension UIConfigurationStateCustomKey {
	static let item = UIConfigurationStateCustomKey("com.whizbang.state.whatsnew")
}

class WhatsNewCell: BaseListCell<FeatureItem> {
	
	private func defaultListContentConfiguration() -> UIListContentConfiguration {
		return .subtitleCell()
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
		state.item = self.item
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
		content.imageProperties.preferredSymbolConfiguration = .init(font: content.textProperties.font, scale: .large)
		content.text = "\(state.item?.title ?? "Unknown")"
		content.secondaryText = "\(state.item?.description ?? "Unknown")"
		content.image = UIImage(systemName: state.item?.image ?? "bandage.fill")
		listContentView.configuration = content
	}
}
