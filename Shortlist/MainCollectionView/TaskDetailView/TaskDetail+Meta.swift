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
//	case reminder
	case photos
//	case options
}

enum DataItem: Hashable {
	case title(TitleItem)
	case notes(NotesItem)
	case photo(PhotoItem)
//	case reminder(ReminderItem)
//	case options(OptionItem)
}

// Maps to TaskPhotos in Core Data
struct PhotoItem: Hashable {
	var id: UUID
	var photo: Data?
	var thumbnail: Data?
	var isButton: Bool
}

struct TitleItem: Hashable {
	var title: String
}

struct NotesItem: Hashable {
	let id: UUID = UUID()
	var notes: String
	// date
	var isButton: Bool
}

struct OptionItem: Hashable {
	var option: String
	// image
}

struct ReminderItem: Hashable {
	var reminder: String // change to date
}
