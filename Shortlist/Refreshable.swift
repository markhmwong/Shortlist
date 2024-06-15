//
//  Refreshable.swift
//  Shortlist
//
//  Created by Mark Wong on 15/6/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import Foundation

protocol Refreshable {
    func refresh(item: SLTask)
}
