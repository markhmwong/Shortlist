import WidgetKit
import SwiftUI

// MARK: - Timeline Entry

struct ShortlistEntry: TimelineEntry {
    let date: Date
    let tasks: [TaskSnapshot]

    var completedCount: Int { tasks.filter(\.isComplete).count }
}

// MARK: - Provider

struct ShortlistProvider: TimelineProvider {
    func placeholder(in context: Context) -> ShortlistEntry {
        ShortlistEntry(date: Date(), tasks: [
            TaskSnapshot(id: UUID(), name: "Buy groceries", priority: 0, isComplete: false),
            TaskSnapshot(id: UUID(), name: "Call the dentist", priority: 1, isComplete: true),
            TaskSnapshot(id: UUID(), name: "Finish report", priority: 2, isComplete: false),
        ])
    }

    func getSnapshot(in context: Context, completion: @escaping (ShortlistEntry) -> Void) {
        completion(ShortlistEntry(date: Date(), tasks: WidgetDataProvider.fetchTodaySnapshots()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ShortlistEntry>) -> Void) {
        let tasks = WidgetDataProvider.fetchTodaySnapshots()
        let entry = ShortlistEntry(date: Date(), tasks: tasks)
        // Reload at 30s past midnight so the widget catches the new day
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let midnight = Calendar.current.date(
            byAdding: .second, value: 30,
            to: Calendar.current.startOfDay(for: tomorrow))!
        completion(Timeline(entries: [entry], policy: .after(midnight)))
    }
}

// MARK: - Widget Definitions

struct ShortlistSmallWidget: Widget {
    let kind = "ShortlistSmall"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ShortlistProvider()) { entry in
            SmallWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Today's Goals")
        .description("See your 3 goals at a glance.")
        .supportedFamilies([.systemSmall])
    }
}

struct ShortlistMediumWidget: Widget {
    let kind = "ShortlistMedium"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ShortlistProvider()) { entry in
            MediumWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Today's Goals")
        .description("Track all 3 goals with detail.")
        .supportedFamilies([.systemMedium])
    }
}

struct ShortlistLockScreenWidget: Widget {
    let kind = "ShortlistLockScreen"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ShortlistProvider()) { entry in
            LockScreenWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Goals")
        .description("Goals progress on your Lock Screen.")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

// MARK: - Small Widget View

struct SmallWidgetView: View {
    let entry: ShortlistEntry

    private var allDone: Bool {
        !entry.tasks.isEmpty && entry.completedCount == entry.tasks.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Today")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(entry.completedCount)/\(entry.tasks.count)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(allDone ? .green : .primary)
            }
            ForEach(entry.tasks.prefix(3)) { GoalRow(task: $0) }
            ForEach(0..<max(0, 3 - entry.tasks.count), id: \.self) { _ in
                EmptyGoalRow()
            }
        }
        .padding(.horizontal, 2)
    }
}

// MARK: - Medium Widget View

struct MediumWidgetView: View {
    let entry: ShortlistEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Today's Goals")
                    .font(.headline.weight(.bold))
                Spacer()
                Text("\(entry.completedCount)/\(entry.tasks.count) done")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            if entry.tasks.isEmpty {
                Spacer()
                Text("Open Shortlist to add your goals.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
            } else {
                ForEach(entry.tasks.prefix(3)) { DetailGoalRow(task: $0) }
                ForEach(0..<max(0, 3 - entry.tasks.count), id: \.self) { _ in
                    EmptyGoalRow()
                }
            }
        }
    }
}

// MARK: - Lock Screen View

struct LockScreenWidgetView: View {
    @Environment(\.widgetFamily) var family
    let entry: ShortlistEntry

    var body: some View {
        switch family {
        case .accessoryCircular:
            Gauge(value: Double(entry.completedCount),
                  in: 0...Double(max(1, entry.tasks.count))) {
                Image(systemName: "checkmark")
            } currentValueLabel: {
                Text("\(entry.completedCount)")
            }
            .gaugeStyle(.accessoryCircular)
        case .accessoryRectangular:
            if let task = entry.tasks.first(where: { !$0.isComplete }) {
                Label(task.name, systemImage: "circle")
                    .font(.caption.weight(.semibold))
                    .lineLimit(2)
            } else if entry.tasks.isEmpty {
                Text("Set your goals")
                    .font(.caption)
            } else {
                Label("All done!", systemImage: "checkmark.circle.fill")
                    .font(.caption.weight(.semibold))
            }
        case .accessoryInline:
            Text("\(entry.completedCount)/\(entry.tasks.count) goals done")
        default:
            EmptyView()
        }
    }
}

// MARK: - Row Components

struct GoalRow: View {
    let task: TaskSnapshot
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(task.isComplete ? .green : .secondary)
                .imageScale(.small)
            Text(task.name)
                .font(.caption)
                .lineLimit(1)
                .strikethrough(task.isComplete)
                .foregroundStyle(task.isComplete ? .secondary : .primary)
        }
    }
}

struct DetailGoalRow: View {
    let task: TaskSnapshot
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(task.isComplete ? .green : .secondary)
            Text(task.name)
                .font(.subheadline)
                .lineLimit(1)
                .strikethrough(task.isComplete)
                .foregroundStyle(task.isComplete ? .secondary : .primary)
            Spacer()
            PriorityDot(priority: task.priority)
        }
    }
}

struct EmptyGoalRow: View {
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "circle.dashed")
                .foregroundStyle(.tertiary)
                .imageScale(.small)
            Text("—")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }
}

struct PriorityDot: View {
    let priority: Int16
    var color: Color {
        switch priority {
        case 0: return .red
        case 1: return .orange
        default: return .yellow
        }
    }
    var body: some View {
        Circle().fill(color).frame(width: 6, height: 6)
    }
}
