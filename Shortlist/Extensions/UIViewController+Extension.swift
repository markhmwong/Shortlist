//
//  UIViewController+Extension.swift
//  Shortlist
//
//  Created by Mark Wong on 17/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

extension UIViewController {
	
	
	// Height of status bar and navigation bar if it exists
	
    var topBarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
