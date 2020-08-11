//
//  MainCollectionView+Meta.swift
//  Shortlist
//
//  Created by Mark Wong on 23/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

enum TaskSection: Int, CaseIterable {
	case high = 0
	case medium
	case low
}

struct TaskItem: Hashable {
	var title: String
	var notes: String
	var priority: Priority
	var completionStatus: Bool
	var reminder: String
}
