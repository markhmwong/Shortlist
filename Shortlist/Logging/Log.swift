//
//  Log.swift
//  Shortlist
//
//  Created by Mark Wong on 16/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import os

private let subsystem = "com.whizbang.shortlist"

struct Log {
    static let task = OSLog(subsystem: subsystem, category: "task")
    static let chart = OSLog(subsystem: subsystem, category: "chart")
}
