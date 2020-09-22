//
//  ReviewCollectionView+Meta.swift
//  Shortlist
//
//  Created by Mark Wong on 17/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

enum ReviewSections {
	case main
}

struct ReviewItem: BaseItem, Hashable {
	var id: UUID = UUID()
	var title: String
	
}
