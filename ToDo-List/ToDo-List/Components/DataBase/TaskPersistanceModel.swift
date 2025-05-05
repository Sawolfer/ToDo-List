//
//  TaskPersistanceModel.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 26.04.2025.
//

import CoreData
import Foundation

final class TaskPersistenceController {
    static let shared = TaskPersistenceController()

    let persistenceController = PersistenceController.shared

    private init() {}

    func updateTask(_ task: ToDoTask) {
        let context = persistenceController.container.newBackgroundContext()

        DispatchQueue.global(qos: .background).async {
            let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)

            do {
                let results = try context.fetch(fetchRequest)
                if let cdTask = results.first {
                    cdTask.update(from: task)
                    try context.save()
                }
            } catch {
                print("Failed to update task: \(error)")
            }
        }
    }

    func saveNewTask(_ task: ToDoTask) {
        let context = persistenceController.container.newBackgroundContext()

        DispatchQueue.global(qos: .background).async {
            let cdTask = CDTask(context: context)
            cdTask.update(from: task)

            do {
                try context.save()
            } catch {
                print("Failed to save new task: \(error)")
            }
        }
    }

    func deleteTask(withId id: UUID) {
        let context = persistenceController.container.newBackgroundContext()

        DispatchQueue.global(qos: .background).async {
            let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                let results = try context.fetch(fetchRequest)
                if let cdTask = results.first {
                    context.delete(cdTask)
                    try context.save()
                }
            } catch {
                print("Failed to delete task: \(error)")
            }
        }
    }
}
