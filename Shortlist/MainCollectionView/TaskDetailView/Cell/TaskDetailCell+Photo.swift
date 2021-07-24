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
    private var busyView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
	
	private func setupViewsIfNeeded() {
		contentView.backgroundColor = ThemeV2.Background

		contentView.addSubview(imageView)
		contentView.addSubview(caption)
        contentView.addSubview(busyView)
        
        busyView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        busyView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
		caption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
		caption.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
		caption.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		
		imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant:0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
	}
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		setupViewsIfNeeded()
		
		guard let item = state.photoItem else {
			imageView.removeFromSuperview()
			return
		}
		
		if (item.isButton) {
            let config = UIImage.SymbolConfiguration(pointSize: 40.0)
			let image = UIImage(systemName: "rectangle.fill.badge.plus", withConfiguration: config)?.imageWithInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))?.withTintColor(ThemeV2.TextColor.DefaultColor)
			imageView.backgroundColor = ThemeV2.Background
			imageView.image = image
            imageView.contentMode = .center
            caption.text = item.caption ?? "None"
		} else {
            // item is in progress updating
            if item.updatingState {
                self.isBusy()
            } else {
                self.isNotBusy()
            }
            
            self.preparePhoto(item: item)
            
            self.prepareVideo(item: item)
		}
	}
    
    private func preparePhoto(item: PhotoItem) {
        if let photo = item.thumbnail {
            let p = UIImage(data: photo)
            imageView.image = p
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 10.0
            imageView.clipsToBounds = true
            caption.text = item.caption ?? "None"
        } else {
            caption.text = "no thumbnail"
        }
    }
    
    private func prepareVideo(item: PhotoItem) {
        if item.videoUrl != nil {
            if !item.updatingState {
                if let thumbnail = item.thumbnail {
                    let p = UIImage(data: thumbnail)
                    imageView.image = p
                    imageView.contentMode = .scaleAspectFill
                    imageView.layer.cornerRadius = 10.0
                    imageView.clipsToBounds = true
                    caption.text = item.caption ?? "None"
                }
            }
        }
    }
    
    func isBusy() {
        busyView.startAnimating()
    }
    
    func isNotBusy() {
        busyView.stopAnimating()
    }
}
    


