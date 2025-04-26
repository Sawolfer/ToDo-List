//
//  AppNetworkManager.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 26.04.2025.
//

import Foundation

class AppNetworkManager {
    private let persistenceController: PersistenceController
    private let apiURL = URL(string: "https://dummyjson.com/todos")!

    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
    }

    func loadInitialTasksIfNeeded(completion: @escaping (Bool) -> Void) {
        guard AppSettings.isFirstLaunch else {
            completion(false)
            return
        }

        loadTasksFromAPI { success in
            if success {
                AppSettings.hasLoadedInitialTasks = true
            }
            completion(success)
        }
    }

    private func loadTasksFromAPI(completion: @escaping (Bool) -> Void) {
        URLSession.shared.dataTask(with: apiURL) { [weak self] data, _, error in
            guard let self = self else {
                completion(false)
                return
            }

            if let error = error {
                print("API Error: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(false)
                return
            }

            do {
                let response = try JSONDecoder().decode(APIResponse.self, from: data)
                self.saveAPITasks(response.todos)
                completion(true)
            } catch {
                print("Decoding error: \(error)")
                completion(false)
            }
        }.resume()
    }

    private func saveAPITasks(_ apiTasks: [APITask]) {
        let context = persistenceController.container.viewContext

        apiTasks.forEach { apiTask in
            let task = Task(
                title: apiTask.todo,
                description: "Imported from API",
                isDone: apiTask.completed,
                createdAt: Date()
            )

            let cdTask = CDTask(context: context)
            cdTask.id = UUID()
            cdTask.title = task.title
            cdTask.descriptionText = task.description
            cdTask.isDone = task.isDone
            cdTask.createdAt = task.createdAt
        }

        do {
            try context.save()
        } catch {
            print("Failed to save API tasks: \(error)")
        }
    }
}

struct APIResponse: Codable {
    let todos: [APITask]
}

struct APITask: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
