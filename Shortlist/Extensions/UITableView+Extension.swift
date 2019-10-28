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
}
