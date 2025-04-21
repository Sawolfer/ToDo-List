//
//  TaskModel.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 20.04.2025.
//

import Foundation

struct Task {
    var id: UUID = UUID()
    var title: String = ""
    var description: String = ""
    var isDone: Bool = false
    let createdAt: Date = Date()
}

extension Task : Identifiable {}

extension Date {
// MARK: - Date view formatter
    var slashedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        let strDate = formatter.string(from: self)
        return strDate
    }
}
