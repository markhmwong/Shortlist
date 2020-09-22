//
//  UIBezierPath.swift
//  Five
//
//  Created by Mark Wong on 24/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

extension UIBezierPath {
    func rotateAroundCenter(angle: CGFloat)
    {
        let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: center.x, y: center.y)
        transform = transform.rotated(by: angle)
        transform = transform.translatedBy(x: -center.x, y: -center.y)
        self.apply(transform)
    }
}
