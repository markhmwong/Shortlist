import CoreData

struct TaskSnapshot: Identifiable, Hashable {
    let id: UUID
    let name: String
    let priority: Int16
    let isComplete: Bool
}

enum WidgetDataProvider {
    static let appGroupID = "group.com.whizbang.Five"

    static func fetchTodaySnapshots() -> [TaskSnapshot] {
        guard let groupURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupID)
        else { return [] }

        let container = NSPersistentContainer(name: "ShortlistModel")
        let storeURL = groupURL.appendingPathComponent("ShortlistModel.sqlite")
        let desc = NSPersistentStoreDescription(url: storeURL)
        desc.shouldMigrateStoreAutomatically = true
        desc.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [desc]

        var loadError: Error?
        container.loadPersistentStores { _, error in loadError = error }
        guard loadError == nil else { return [] }

        let context = container.viewContext
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let startOfTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday)!

        let request = NSFetchRequest<NSManagedObject>(entityName: "SLTask")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "taskToStatus.name IN %@", ["Incomplete", "Complete"]),
            NSPredicate(format: "createdAt >= %@ AND createdAt < %@",
                        startOfToday as NSDate, startOfTomorrow as NSDate),
        ])
        request.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true)]

        let objects = (try? context.fetch(request)) ?? []
        return objects.prefix(3).compactMap { obj in
            guard let id = obj.value(forKey: "id") as? UUID,
                  let name = obj.value(forKey: "name") as? String else { return nil }
            let statusObj = obj.value(forKey: "taskToStatus") as? NSManagedObject
            let status = statusObj?.value(forKey: "name") as? String
            let priority = obj.value(forKey: "priority") as? Int16 ?? 0
            return TaskSnapshot(id: id, name: name, priority: priority, isComplete: status == "Complete")
        }
    }
}
