//
//  TaskRedactorViewModel.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 21.04.2025.
//

import SwiftUI
import Foundation

class TaskRedactorViewModel: ObservableObject {
    @Published var task: Task
    var isNewTask: Bool
    private var originalTask: Task

    init(task: Task, isNewTask: Bool = false) {
        self.task = task
        self.originalTask = task
        self.isNewTask = isNewTask
    }

    var hasChanges: Bool {
        task.title != originalTask.title || task.description != originalTask.description
    }

    func saveChanges() {
        originalTask = task
    }

    func saveNewTask() -> Task {
        return Task(title: "", description: "", isDone: false)
    }
}
