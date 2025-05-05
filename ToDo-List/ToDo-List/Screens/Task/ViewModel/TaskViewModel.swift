//
//  TaskViewModel.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 20.04.2025.
//

import Foundation

class TaskViewModel: ObservableObject {
    @Published var task: ToDoTask
    var onDeleteHandler: (() -> Void)?

    init(task: ToDoTask) {
        self.task = task
    }

    func onDone() {
        task.isDone.toggle()

        TaskPersistenceController.shared.updateTask(task)
    }

    func onDelete() {
        TaskPersistenceController.shared.deleteTask(withId: task.id)
        onDeleteHandler?()
    }
}

extension TaskViewModel: Identifiable {}
