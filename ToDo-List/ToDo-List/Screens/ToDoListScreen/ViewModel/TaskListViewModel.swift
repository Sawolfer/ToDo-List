//
//  TaskListViewModel.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 24.04.2025.
//

import Foundation
import CoreData

class TaskListViewModel: ObservableObject {
    @Published var tasks: [TaskViewModel] = []
    @Published var searchText: String = ""
    private let persistenceController: PersistenceController
    private let networkManager: AppNetworkManager

    init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
        self.networkManager = AppNetworkManager(persistenceController: persistenceController)
        loadInitialData()
    }

    private func loadInitialData() {
        loadLocalTasks()

        networkManager.loadInitialTasksIfNeeded { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.loadLocalTasks() // Reload with new API tasks
                }
            }
        }
    }

    @Published var errorMessage: String?
    
    func loadLocalTasks() {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()

        do {
            let cdTasks = try context.fetch(fetchRequest)
            self.tasks = cdTasks
                .map { TaskViewModel(task: ToDoTask(cdTask: $0)) }
                .sorted { $0.task.createdAt > $1.task.createdAt }
        } catch {
            errorMessage = "Failed to fetch tasks: \(error.localizedDescription)"
            print("Failed to fetch tasks: \(error)")
        }
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

    func createNewTask() -> TaskViewModel {
        let newTask = ToDoTask(title: "", description: "")
        let newViewModel = TaskViewModel(task: newTask)
        tasks.append(newViewModel)
        return newViewModel
    }

    func addTask(title: String, description: String = "") {
        let newTask = ToDoTask(title: title, description: description)
        tasks.append(TaskViewModel(task: newTask))
    }

    func deleteTasks(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }

    func deleteTask(_ task: TaskViewModel) {
        tasks.removeAll() { $0 === task}
    }

    static func sampleData() -> TaskListViewModel {
        let vm = TaskListViewModel()
        vm.tasks = [
            TaskViewModel(task: ToDoTask(title: "Buy groceries", description: "Milk, eggs, bread", isDone: true)),
            TaskViewModel(task: ToDoTask(title: "Finish project", description: "Due by Friday")),
            TaskViewModel(task: ToDoTask(title: "Call mom", description: "Ask about vacation plans"))
        ]
        return vm
    }
}
