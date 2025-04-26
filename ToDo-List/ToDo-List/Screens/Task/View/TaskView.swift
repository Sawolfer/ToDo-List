//
//  TaskView.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 20.04.2025.
//

import SwiftUI

struct TaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.colorScheme) var colorScheme
    var onLongPress: (() -> Void)? = nil

    var body: some View {
        let theme = AppTheme.theme(for: colorScheme)

        HStack {
            VStack {
                Button(action: {
                    viewModel.onDone()
                }) {
                    Image(systemName: viewModel.task.isDone ? "checkmark.circle" : "circle")
                        .foregroundColor(!viewModel.task.isDone ? theme.colors.secondary : theme.colors.accent)
                        .imageScale(.large)
                }
                Spacer()
            }
            VStack(alignment: .leading) {
                Text(viewModel.task.title)
                    .strikethrough(viewModel.task.isDone, color: theme.colors.secondary)
                    .foregroundColor(viewModel.task.isDone ? theme.colors.secondary : theme.colors.text)
                    .font(theme.fonts.headline)
                Text(viewModel.task.description)
                    .font(theme.fonts.subheadline)
                    .foregroundColor(viewModel.task.isDone ? theme.colors.secondary : theme.colors.text)
                Text(viewModel.task.createdAt.slashedDate)
                    .font(theme.fonts.caption)
                    .foregroundColor(theme.colors.dateText)
            }
            Spacer()
        }
        .padding(theme.dimensions.padding)
        .background(theme.colors.background)
        .cornerRadius(10)
        .onLongPressGesture {
            onLongPress?()
        }
    }
}
