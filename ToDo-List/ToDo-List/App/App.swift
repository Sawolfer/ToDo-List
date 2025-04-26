//
//  App.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 19.04.2025.
//

import Foundation
import SwiftUI

@main
struct ToDoListApp: App {
    @StateObject private var taskListVM = TaskListViewModel()

    var body: some Scene {
        WindowGroup {
            TaskListView(viewModel: taskListVM)
        }
    }
}
