//
//  NewTaskStructs.swift
//  Shortlist
//
//  Created by Mark Wong on 28/1/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import Foundation

protocol TaskDetailProtocol {
	var section: NewTaskDetailSection { get set }
}

struct NewTaskDetailHeaderItem: Hashable, TaskDetailProtocol {
	var priority: String
	var reminder: String
	var redact: Bool
	var section: NewTaskDetailSection
}

// Task name
struct NewTaskDetailTitleItem: Hashable, TaskDetailProtocol {
	var name: String
	var section: NewTaskDetailSection
}

// Task name
struct NewTaskDetailNoteItem: Hashable, TaskDetailProtocol {
	var name: String
	var section: NewTaskDetailSection
}

// Maps to TaskPhotos in Core Data
struct NewTaskDetailPhotoItem: Hashable {
	var id: UUID
	var photo: Data?
	var thumbnail: Data?
	var isButton: Bool
	var section: NewTaskDetailSection
}

enum NewTaskDetailSection: Int, CaseIterable {
	case header
	case taskName
//	case notes
	case photo
}
//
//enum DataItem: Hashable {
////	case header(HeaderItem)
//	case title(TitleItem)
//	case photo(PhotoItem)
////	case header(NewTaskDetailHeaderItem)
////	case title(NewTaskDetailTitleItem)
////	case photo(NewTaskDetailPhotoItem)
//
////	var section: NewTaskDetailSection {
////		switch self {
//////			case .header(let item):
//////				return item.section
//////			case .title(let item):
//////				return item.section
//////			case .photo(let item):
//////				return item.section
////		}
////	}
//	case notes(NotesItem)
////	case reminder(ReminderItem)
////	case options(OptionItem)
//}
