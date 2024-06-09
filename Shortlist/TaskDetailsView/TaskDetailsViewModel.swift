//
//  TaskDetailsViewModel.swift
//  Shortlist
//
//  Created by Mark on 10/5/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import CoreData

class TaskDetailsViewModel: NSObject {
	
//	private var item: SLTask
	
	let item: Binding<SLTask>
	
	init(item: SLTask) {
		self.item = Binding(value: item)
		super.init()
		
	}
	
	
}
