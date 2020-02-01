//
//  PointSegment.swift
//  Shortlist
//
//  Created by Mark Wong on 9/12/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct LineSegment {
    let startPoint: CGPoint
    let endPoint: CGPoint
}

struct CurvedSegment {
    var controlPoint1: CGPoint
    var controlPoint2: CGPoint
}
