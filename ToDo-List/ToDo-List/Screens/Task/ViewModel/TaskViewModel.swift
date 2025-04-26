//
//  TaskViewModel.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 20.04.2025.
//

import Foundation

class TaskViewModel: ObservableObject {
    @Published var task: Task

    init(task: Task) {
        self.task = task
    }

    func onDone() {
        task.isDone.toggle()

        TaskPersistenceController.shared.updateTask(task)
    }
}

extension TaskViewModel: Identifiable {}
