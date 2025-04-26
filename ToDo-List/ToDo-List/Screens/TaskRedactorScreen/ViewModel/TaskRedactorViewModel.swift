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
    @Published var task: Task
    var isNewTask: Bool
    private var originalTask: Task
    private let persistenceController: PersistenceController

    init(task: Task, isNewTask: Bool = false) {
        self.task = task
        self.originalTask = task
        self.isNewTask = isNewTask
        self.persistenceController = PersistenceController.shared
    }

    var hasChanges: Bool {
        task.title != originalTask.title || task.description != originalTask.description
    }

    func saveChanges() {
        guard hasChanges else { return }

        TaskPersistenceController.shared.updateTask(task)
        originalTask = task
    }

    func saveNewTask() {
        TaskPersistenceController.shared.saveNewTask(task)
    }
}
