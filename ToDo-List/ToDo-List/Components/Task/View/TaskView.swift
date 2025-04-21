//
//  TaskView.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 20.04.2025.
//

import SwiftUI

struct TaskView: View {
    @ObservedObject var viewModel: TaskViewModel

    var body: some View {
// MARK: - todo item view changer
        HStack {
            VStack {
                Button(action: {
                    viewModel.onDone()
                }) {
                    Image(systemName: viewModel.task.isDone ? "checkmark.circle" : "circle")
                        .foregroundColor(viewModel.task.isDone ? .green : .gray)
                        .imageScale(.large)
                }
                Spacer()
            }
            VStack(alignment: .leading) {
                Text(viewModel.task.title)
                    .strikethrough(viewModel.task.isDone, color: .gray)
                    .foregroundColor(viewModel.task.isDone ? .gray : .primary)
                    .font(.headline)
                Text(viewModel.task.description)
                    .font(.subheadline)
                    .foregroundStyle(viewModel.task.isDone ? .secondary : .primary)
                Text(viewModel.task.createdAt.slashedDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(viewModel.task.isDone ? Color.gray.opacity(0.1) : Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
