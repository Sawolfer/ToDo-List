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


    init (task: Task) {
        self.task = task
    }

    func onSave(_ title: String, _ desc: String) {
        self.task.title = title
        self.task.description = desc
    }
}

