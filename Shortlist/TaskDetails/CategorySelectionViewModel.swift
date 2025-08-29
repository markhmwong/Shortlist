//  CategorySelectionViewModel.swift
//  Shortlist
//
//  Created by Assistant on 6/7/2025.
//

import Foundation

class CategorySelectionViewModel {
    let categories: [AssetManager.CategoryAssets]
	let task : SLTask
    init(task: SLTask) {
        // Use all cases of CategoryAssets
        self.categories = [.general, .personal, .family, .work, .home]
		self.task = task
    }
}
