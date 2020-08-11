//
//  TaskDetail+Meta.swift
//  Shortlist
//
//  Created by Mark Wong on 30/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

enum TaskDetailSections: Int, CaseIterable {
	case title = 0
	case note
	case reminder
	case photos
//	case options
}

enum DataItem: Hashable {
	case title(TitleItem)
	case notes(NotesItem)
	case photo(PhotoItem)
	case reminder(ReminderItem)
//	case options(OptionItem)
}

struct PhotoItem: Hashable {
	var photo: String
}

struct TitleItem: Hashable {
	var title: String
}

struct NotesItem: Hashable {
	var notes: String
}

struct OptionItem: Hashable {
	var option: String
	// image
}

struct ReminderItem: Hashable {
	var reminder: String // change to date
}
