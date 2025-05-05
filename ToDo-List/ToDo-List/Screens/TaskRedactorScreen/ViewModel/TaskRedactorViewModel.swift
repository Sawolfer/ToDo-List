//
//  TaskRedactorViewModel.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 21.04.2025.
//

import SwiftUI
import Foundation
import CoreData

class TaskRedactorViewModel: ObservableObject {
    @Published var task: ToDoTask
    private let persistenceController: PersistenceController
    var isNewTask: Bool
    var onSave: (() -> Void)?

    init(task: ToDoTask, isNewTask: Bool = false, persistenceController: PersistenceController = .shared, onSave: (() -> Void)? = nil) {
        self.task = task
        self.isNewTask = isNewTask
        self.persistenceController = persistenceController
        self.onSave = onSave
    }

    func saveTask() {
        let context = persistenceController.container.viewContext

        if isNewTask {
            // Create new CoreData entity
            let newTask = CDTask(context: context)
            newTask.id = UUID()
            newTask.title = task.title
            newTask.descriptionText = task.description
            newTask.isDone = task.isDone
            newTask.createdAt = Date()
        } else {
            // Update existing task
            let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)

            do {
                if let existingTask = try context.fetch(fetchRequest).first {
                    existingTask.title = task.title
                    existingTask.descriptionText = task.description
                    existingTask.isDone = task.isDone
                }
            } catch {
                print("Failed to fetch task: \(error)")
            }
        }

        do {
            try context.save()
            onSave?()
        } catch {
            print("Failed to save task: \(error)")
        }
    }
}

extension TaskRedactorViewModel: Hashable {
    static func == (lhs: TaskRedactorViewModel, rhs: TaskRedactorViewModel) -> Bool {
        lhs.task.id == rhs.task.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(task.id)
    }
}
