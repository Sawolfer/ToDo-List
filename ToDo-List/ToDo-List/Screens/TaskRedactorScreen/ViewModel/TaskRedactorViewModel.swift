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
    private var originalTask: Task

    init(task: Task) {
        self.task = task
        self.originalTask = task
    }

    var hasChanges: Bool {
        task.title != originalTask.title || task.description != originalTask.description
    }


    func saveChanges() {
        originalTask = task
    }

    
    func discardChanges() {
        task = originalTask
    }
}
