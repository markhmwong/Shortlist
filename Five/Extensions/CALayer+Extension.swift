//
//  CALayerExtension.swift
//  BarChart
//
//  Created by Nguyen Vu Nhat Minh on 21/5/19.
//  Copyright © 2019 Nguyen Vu Nhat Minh. All rights reserved.
//

import UIKit

extension CALayer {
    
    func addChartTitleLayer(frame: CGRect, color: CGColor, fontSize: CGFloat, text: String) {
        let textLayer = CATextLayer()
        textLayer.frame = frame
        textLayer.foregroundColor = color
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.left
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
        textLayer.fontSize = fontSize
        textLayer.string = text
        self.addSublayer(textLayer)
        
//        if animated, let oldFrame = oldFrame {
//            // "frame" property is not animatable in CALayer, so, I use "position" instead
//            // Position is at the center of the frame (if you don't change the anchor point)
//            let oldPosition = CGPoint(x: oldFrame.midX, y: oldFrame.midY)
//            textLayer.animate(fromValue: oldPosition, toValue: textLayer.position, keyPath: "position")
//        }
    }
    
    func addRectangleLayer(frame: CGRect, color: CGColor) {
        let layer = CALayer()
        layer.frame = frame
        layer.backgroundColor = UIColor.orange.adjust(by: 10)?.cgColor
        layer.borderColor = UIColor.orange.darker()?.cgColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 0.8
        self.addSublayer(layer)
        
//        if animated, let oldFrame = oldFrame {
//            layer.animate(fromValue: CGPoint(x: oldFrame.midX, y: oldFrame.midY), toValue: layer.position, keyPath: "position")
////            layer.animate(fromValue: CGRect(x: 0, y: 0, width: oldFrame.width, height: oldFrame.height), toValue: layer.bounds, keyPath: "bounds")
//        }
    }
    
    func animate(fromValue: Any, toValue: Any, keyPath: String) {
        let anim = CABasicAnimation(keyPath: keyPath)
        anim.fromValue = fromValue
        anim.toValue = toValue
        anim.duration = 0.5
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.add(anim, forKey: keyPath)
    }
}
