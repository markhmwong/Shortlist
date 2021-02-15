//
//  TaskDetail+Meta.swift
//  Shortlist
//
//  Created by Mark Wong on 30/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

struct TaskDetailSupplementaryView {
	static var Header: String = "com.whizbang.taskdetail.header"
}

enum TaskDetailSections: Int, CaseIterable {
	case title = 0
	case note
	case photos
//	case reminder
	
//	case options
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

enum DataItem: Hashable {
//	case header(HeaderItem)
	case title(TitleItem)
	case photo(PhotoItem)
//	case header(NewTaskDetailHeaderItem)
//	case title(NewTaskDetailTitleItem)
//	case photo(NewTaskDetailPhotoItem)

//	var section: NewTaskDetailSection {
//		switch self {
////			case .header(let item):
////				return item.section
////			case .title(let item):
////				return item.section
////			case .photo(let item):
////				return item.section
//		}
//	}
	case notes(NotesItem)
//	case reminder(ReminderItem)
//	case options(OptionItem)
}
