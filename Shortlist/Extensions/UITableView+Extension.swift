//
//  UITableView+Extension.swift
//  Shortlist
//
//  Created by Mark Wong on 24/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
		self.backgroundView = EmptyCollectionView(message: message)
    }
    
    func restoreBackgroundView() {
        self.backgroundView = nil
    }
	
	func updateHeaderViewHeight() {
		// header view setup for dynamic height
		guard let headerView = self.tableHeaderView else {
		  return
		}
		
		headerView.anchorView(top: self.topAnchor, bottom: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0))
		headerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
		
		let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

		if (headerView.frame.size.height != size.height) {
			headerView.frame.size.height = size.height
			self.tableHeaderView = headerView
//			DispatchQueue.main.async {
				self.layoutIfNeeded()
//			}
		}
    }
	
}
