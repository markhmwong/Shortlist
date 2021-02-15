//
//  UIApplication+Extension.swift
//  Shortlist
//
//  Created by Mark Wong on 25/1/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit

extension UIApplication {
	var currentScene: UIWindowScene? {
		connectedScenes
			.first { $0.activationState == .foregroundActive } as? UIWindowScene
	}
}
