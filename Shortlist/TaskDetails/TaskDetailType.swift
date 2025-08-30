//
//  TaskDetailType.swift
//  Shortlist
//
//  Created by Mark Wong on 4/7/2025.
//  Copyright © 2025 Mark Wong. All rights reserved.
//

import Foundation

protocol TaskDetailType: Hashable {
	var title: String { get }
	var value: TaskDetailValueType? { get }
	var section: TaskDetailsViewModel.Section { get }
}

enum TaskDetailCellType {
	case textFIeld
	case textView
	case selectable
	case date
}

// MARK: Task Detail Types
/// A selectable task detail that includes a title and the selected value
struct SelectableTaskDetail: TaskDetailType, Hashable {
	var title: String
	var value: TaskDetailValueType?
	var section: TaskDetailsViewModel.Section
}

/// Text view with a title. Designed for longer inputs like task descriptions.
struct WritableContentTaskDetail: TaskDetailType, Hashable {
	var title: String
	var value: TaskDetailValueType?
	var section: TaskDetailsViewModel.Section
}

/// Text field with a title. Designed for shorter inputs like names or titles.
struct WritableTaskDetail: TaskDetailType, Hashable {
	var title: String
	var value: TaskDetailValueType?
	var section: TaskDetailsViewModel.Section
}

struct DateTaskDetail: TaskDetailType, Hashable {
	var title: String
	var value: TaskDetailValueType?
	var section: TaskDetailsViewModel.Section
}

enum TaskDetailValueType: Hashable {
	case string(String)
	case int(Int)
	case date(Date)
	case none

	var stringValue: String? {
		switch self {
			case .string(let str):
				return str
			case .int(let int):
				return String(int)
			case .date(let date):
				let formatter = DateFormatter()
				formatter.dateStyle = .medium
				formatter.timeStyle = .short
				return formatter.string(from: date)
			case .none:
				return nil
		}
	}

	var dateValue: Date? {
		if case .date(let date) = self {
			return date
		}
		return nil
	}
}

// MARK: Type Erasure for TaskDetailType
struct AnyTaskDetailItem: Hashable {
    private let base: any TaskDetailType & Hashable
	var title: String {
		base.title
	}

	var value: TaskDetailValueType? {
		base.value
	}

	var section: TaskDetailsViewModel.Section {
		base.section
	}

    init(_ base: some TaskDetailType & Hashable) {
        self.base = base
    }

    static func == (lhs: AnyTaskDetailItem, rhs: AnyTaskDetailItem) -> Bool {
        lhs.base.isEqual(to: rhs.base)
    }

    func hash(into hasher: inout Hasher) {
        base.hash(into: &hasher)
    }
}

private extension TaskDetailType where Self: Hashable {
    func isEqual(to other: Any) -> Bool {
        guard let other = other as? Self else { return false }
        return self == other
    }
}
