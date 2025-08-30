//  CategorySelectionViewModel.swift
//  Shortlist
//
//  Created by Assistant on 6/7/2025.
//

import Foundation

public class CategorySelectionViewModel {

    public let categories: [AssetManager.Category]
	public let task : SLTask

	public let cds: CoreDataStack

	public init(task: SLTask, cds: CoreDataStack) {
        // Use all cases of CategoryAssets
        self.categories = [.general, .personal, .family, .work, .home]
		self.task = task
		self.cds = cds
    }
}
