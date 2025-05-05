//
//  TaskRedactorView.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 21.04.2025.
//

import SwiftUI

struct TaskRedactorView: View {

    // MARK: - Constants
    private enum Constants {
        static var backwardButtonImage: String = "chevron.backward"
        static var bacwardButtonLable: String = "Назад"
        static var bacwardButtonImageSize: CGFloat = 20
    }

    // MARK: - Properties
    @ObservedObject var taskVM: TaskRedactorViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        let theme = AppTheme.theme(for: colorScheme)

        NavigationStack {
            VStack(alignment: .leading, spacing: 8) {
                TextField("Название задачи", text: $taskVM.task.title)
                    .font(.system(.largeTitle, design: .default))
                    .bold()
                    .padding(.horizontal)
                    .padding(.top)

                if !taskVM.isNewTask {
                    Text(taskVM.task.createdAt.slashedDate)
                        .font(theme.fonts.subheadline)
                        .foregroundStyle(theme.colors.dateText)
                        .padding(.horizontal)
                }

                TextEditor(text: $taskVM.task.description)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .top)
                    .background(theme.colors.background)
            }
            .background(theme.colors.background)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                // Back button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        handleSaveAndDismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: Constants.backwardButtonImage)
                                .font(.system(size: Constants.bacwardButtonImageSize, weight: .bold))
                            Text(Constants.bacwardButtonLable)
                        }
                    }
                    .foregroundStyle(theme.colors.accent)
                }
            }
        }
    }

    private func handleSaveAndDismiss() {
        if !taskVM.task.title.isEmpty {
            taskVM.saveTask()
        }
        dismiss()
    }
}

extension TaskRedactorView : Hashable {
    static func == (lhs: TaskRedactorView, rhs: TaskRedactorView) -> Bool {
        lhs.taskVM == rhs.taskVM
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(taskVM)
    }
}

#Preview {
    TaskRedactorView(taskVM: TaskRedactorViewModel(task: ToDoTask(title: "Preview Task", description: "some text")))
}

