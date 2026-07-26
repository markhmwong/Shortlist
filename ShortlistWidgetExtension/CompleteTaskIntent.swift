import AppIntents
import CoreData
import WidgetKit

@available(iOS 17.0, *)
struct CompleteTaskIntent: AppIntent {
    static var title: LocalizedStringResource = "Complete Goal"
    static var description = IntentDescription("Mark a Shortlist goal as complete.")
    static var openAppWhenRun: Bool = false

    @Parameter(title: "Task ID")
    var taskID: String

    func perform() async throws -> some IntentResult {
        let container = makeContainer()
        let context = container.newBackgroundContext()
        try await context.perform {
            guard let uuid = UUID(uuidString: taskID) else { return }
            let request = NSFetchRequest<NSManagedObject>(entityName: "SLTask")
            request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
            guard let task = try context.fetch(request).first,
                  let status = task.value(forKey: "taskToStatus") as? NSManagedObject else { return }
            status.setValue("Complete", forKey: "name")
            try context.save()
        }
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }

    private func makeContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "ShortlistModel")
        if let groupURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.whizbang.Five") {
            let storeURL = groupURL.appendingPathComponent("ShortlistModel.sqlite")
            let desc = NSPersistentStoreDescription(url: storeURL)
            desc.shouldMigrateStoreAutomatically = true
            desc.shouldInferMappingModelAutomatically = true
            container.persistentStoreDescriptions = [desc]
        }
        container.loadPersistentStores { _, _ in }
        return container
    }
}
