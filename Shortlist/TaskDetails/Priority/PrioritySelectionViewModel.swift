//
//  PrioritySelectionViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 31/8/2025.
//  Copyright © 2025 Mark Wong. All rights reserved.
//


public class PrioritySelectionViewModel {

    let priorities: [TaskPriorityLevel] = TaskPriorityLevel.allCases
    var selectedPriority: TaskPriorityLevel?
	var task: SLTask

	public init(selectedPriority: TaskPriorityLevel? = nil, task: SLTask) {
		self.task = task
		self.selectedPriority = TaskPriorityLevel(rawValue: Int(task.priority)) //TODO: FIX to INT from INT16
    }
}