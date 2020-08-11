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

extension UIToolbar {
	func addToolBar(textField: UITextField) -> UIToolbar {
		let toolBar = UIToolbar()
		toolBar.barStyle = UIBarStyle.default
		toolBar.isTranslucent = true
		toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
		let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePressed))
		toolBar.setItems([doneButton], animated: false)
		toolBar.isUserInteractionEnabled = true
		toolBar.sizeToFit()

//		textField.delegate = self
		textField.inputAccessoryView = toolBar
		return toolBar
	}
	
	@objc func donePressed(){
		endEditing(true)
	}

}
