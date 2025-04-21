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
    var body: some Scene {
        WindowGroup {
//            ToDoListView()
            TaskRedactorView(taskVM: TaskRedactorViewModel(task: Task(title: "Preview Task", description: "some text")))
        }
    }
}
