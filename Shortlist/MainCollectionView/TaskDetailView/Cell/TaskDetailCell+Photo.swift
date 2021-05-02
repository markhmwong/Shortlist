//
//  TaskDetailCell+Photo.swift
//  Shortlist
//
//  Created by Mark Wong on 18/2/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit

// MARK: - Photo Cell
extension UICellConfigurationState {
	var photoItem: PhotoItem? {
		set { self[.photoItem] = newValue }
		get { return self[.photoItem] as? PhotoItem }
	}
}

fileprivate extension UIConfigurationStateCustomKey {
	static let photoItem = UIConfigurationStateCustomKey("com.whizbang.shortlist.taskdetail.photo")
}

class TaskDetailPhotoCell: BaseCell<PhotoItem> {
	
	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.photoItem = self.item
		return state
	}
	
	private var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 0.1 // ??
		return imageView
	}()
	
	private var caption: UILabel = {
		let label = UILabel()
        label.textAlignment = .center
		label.alpha = 0.7
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Caption"
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
		return label
	}()
	
	private func setupViewsIfNeeded() {
		contentView.backgroundColor = ThemeV2.Background

		contentView.addSubview(imageView)
		contentView.addSubview(caption)
		
		caption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
		caption.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
		caption.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		
		imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant:30).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
	}
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		setupViewsIfNeeded()
		
		guard let item = state.photoItem else {
			imageView.removeFromSuperview()
			return
		}
		
		if (item.isButton) {
			let config = UIImage.SymbolConfiguration(pointSize: 20.0)
			let image = UIImage(systemName: "rectangle.fill.badge.plus", withConfiguration: config)?.imageWithInsets(insets: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))?.withTintColor(ThemeV2.TextColor.DefaultColor)
			imageView.backgroundColor = ThemeV2.Background
			imageView.image = image
			imageView.contentScaleFactor = 0.5
            caption.text = item.caption ?? "None"
		} else {
			if let photo = item.thumbnail {
				let p = UIImage(data: photo)
				imageView.image = p
                caption.text = item.caption ?? "None"
			}
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
	}
}
