//
//  TaskModel.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 20.04.2025.
//

import CoreData
import Foundation

struct ToDoTask {
    var id: UUID = UUID()
    var title: String = ""
    var description: String = ""
    var isDone: Bool = false
    var createdAt: Date = Date()

    func saveTask(_ task: ToDoTask, context: NSManagedObjectContext) {
        let cdTask = CDTask(context: context)
        cdTask.update(from: task)

        do {
            try context.save()
        } catch {
            print("Failed to save task: \(error)")
        }
    }

    func fetchTasks(context: NSManagedObjectContext) -> [ToDoTask] {
        let request: NSFetchRequest<CDTask> = CDTask.fetchRequest()
        do {
            let cdTasks = try context.fetch(request)
            return cdTasks.map(ToDoTask.init)
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }

    func deleteTask(_ task: ToDoTask, context: NSManagedObjectContext) {
        let request: NSFetchRequest<CDTask> = CDTask.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)

        do {
            let results = try context.fetch(request)
            for object in results {
                context.delete(object)
            }
            try context.save()
        } catch {
            print("Failed to delete task: \(error)")
        }
    }
}

extension ToDoTask: Identifiable, Hashable {
    static func == (lhs: ToDoTask, rhs: ToDoTask) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Date {
    // MARK: - Date view formatter
    var slashedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        let strDate = formatter.string(from: self)
        return strDate
    }
}
// MARK: - Core Data
extension CDTask {
    func update(from task: ToDoTask) {
        self.id = task.id
        self.title = task.title
        self.descriptionText = task.description
        self.isDone = task.isDone
        self.createdAt = task.createdAt
    }
}

extension ToDoTask {
    init(cdTask: CDTask) {
        self.id = cdTask.id ?? UUID()
        self.title = cdTask.title ?? ""
        self.description = cdTask.descriptionText ?? ""
        self.isDone = cdTask.isDone
        self.createdAt = cdTask.createdAt ?? Date()
    }
}
