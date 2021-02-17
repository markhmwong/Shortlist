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
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "CaptionCaptionCaptionCaptionCaptionCaptionCaptionCaption"
		label.font = UIFont.preferredFont(forTextStyle: .caption2)
		return label
	}()
	
	private func setupViewsIfNeeded() {
		contentView.backgroundColor = ThemeV2.Background

		contentView.addSubview(imageView)
		contentView.addSubview(caption)
		
		caption.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
		caption.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
		caption.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
		caption.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		
		imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant:0).isActive = true
		imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//		imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
	}
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		setupViewsIfNeeded()
		
		guard let item = state.photoItem else {
			imageView.removeFromSuperview()
			return
		}
		
		if (item.isButton) {
			let config = UIImage.SymbolConfiguration(pointSize: 20.0)
			let image = UIImage(systemName: "camera.fill", withConfiguration: config)?.imageWithInsets(insets: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))?.withTintColor(ThemeV2.TextColor.DefaultColor)
			imageView.backgroundColor = ThemeV2.Background
			imageView.image = image
			imageView.contentScaleFactor = 0.5
		} else {
			if let photo = item.thumbnail {
				let p = UIImage(data: photo)
				imageView.image = p
			}
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
	}
}
