//
//  TaskListViewModel.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 24.04.2025.
//

import Foundation

class TaskListViewModel: ObservableObject {
    @Published var tasks: [TaskViewModel] = []
    @Published var searchText: String = ""

    init(tasks: [Task] = []) {
        self.tasks = tasks.map { TaskViewModel(task: $0) }
    }

    var filteredTasks: [TaskViewModel] {
        if searchText.isEmpty {
            return tasks
        } else {
            return tasks.filter {
                $0.task.title.localizedCaseInsensitiveContains(searchText) ||
                $0.task.description.localizedCaseInsensitiveContains(searchText) }
        }
    }

    func addTask(title: String, description: String = "") {
        let newTask = Task(title: title, description: description)
        tasks.append(TaskViewModel(task: newTask))
    }

    func deleteTasks(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }

    static func sampleData() -> TaskListViewModel {
        let vm = TaskListViewModel()
        vm.tasks = [
            TaskViewModel(task: Task(title: "Buy groceries", description: "Milk, eggs, bread", isDone: true)),
            TaskViewModel(task: Task(title: "Finish project", description: "Due by Friday")),
            TaskViewModel(task: Task(title: "Call mom", description: "Ask about vacation plans"))
        ]
        return vm
    }
}
