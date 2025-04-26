//
//  TaskModel.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 20.04.2025.
//

import Foundation
import CoreData

struct Task {
    var id: UUID = UUID()
    var title: String = ""
    var description: String = ""
    var isDone: Bool = false
    var createdAt: Date = Date()

    func saveTask(_ task: Task, context: NSManagedObjectContext) {
        let cdTask = CDTask(context: context)
        cdTask.update(from: task)

        do {
            try context.save()
        } catch {
            print("Failed to save task: \(error)")
        }
    }

    func fetchTasks(context: NSManagedObjectContext) -> [Task] {
        let request: NSFetchRequest<CDTask> = CDTask.fetchRequest()
        do {
            let cdTasks = try context.fetch(request)
            return cdTasks.map(Task.init)
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }
    
    func deleteTask(_ task: Task, context: NSManagedObjectContext) {
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

extension Task : Identifiable, Hashable {
    static func == (lhs: Task, rhs: Task) -> Bool {
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
    func update(from task: Task) {
        self.id = task.id
        self.title = task.title
        self.descriptionText = task.description
        self.isDone = task.isDone
        self.createdAt = task.createdAt
    }
}

extension Task {
    init(cdTask: CDTask) {
        self.id = cdTask.id ?? UUID()
        self.title = cdTask.title ?? ""
        self.description = cdTask.descriptionText ?? ""
        self.isDone = cdTask.isDone
        self.createdAt = cdTask.createdAt ?? Date()
    }
}
