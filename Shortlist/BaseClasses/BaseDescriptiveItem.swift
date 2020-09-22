//
//  BaseItem.swift
//  Shortlist
//
//  Created by Mark Wong on 13/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

protocol BaseDescriptiveItem {
	var title: String { get set }
	var description: String { get set }
	var image: String { get set }
}

protocol BaseItem {
	var title: String { get set }
}
