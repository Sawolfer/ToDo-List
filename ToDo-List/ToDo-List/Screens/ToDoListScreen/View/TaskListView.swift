//
//  TaskListView.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 19.04.2025.
//

import SwiftUI


struct TaskListView: View {
    // MARK: - Constants
    private enum Constants {
        static let addNewToDoButtonImage: String = "square.and.pencil"
    }

    // MARK: - Properties
    @ObservedObject var viewModel: TaskListViewModel
    @Environment(\.colorScheme) var colorScheme
    @State var refreshID: UUID = UUID()

    var body: some View {
        let theme = AppTheme.theme(for: colorScheme)
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.filteredTasks) { vm in
                        NavigationLink {
                            TaskRedactorView(
                                taskVM: TaskRedactorViewModel(
                                    task: vm.task,
                                    onSave: { [weak viewModel] in
                                        viewModel?.loadTasks()
                                        refreshID = UUID()
                                    }
                                )
                            )
                        } label: {
                            TaskView(viewModel: vm)
                        }
                        .buttonStyle(.plain)

                        Divider()
                            .background(theme.colors.secondary)
                            .padding(.horizontal)
                    }
                }
                .id(refreshID)
            }
            .searchable(text: $viewModel.searchText)
            .navigationTitle("Задачи")
            .toolbarBackground(theme.colors.secondary.opacity(0.3), for: .bottomBar)
            .toolbarBackground(.visible, for: .bottomBar)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }

                ToolbarItem(placement: .bottomBar) {
                    Text("\(viewModel.tasks.count) Задач")
                        .font(theme.fonts.subheadline)
                        .foregroundColor(theme.colors.text)
                }

                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }

                ToolbarItem(placement: .bottomBar) {
                    NavigationLink {
                        makeNewTaskRedactorView()
                    } label: {
                        Image(systemName: Constants.addNewToDoButtonImage)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(theme.colors.accent)
                    }
                }
            }
            .onAppear {
                viewModel.loadTasks()
            }
        }
    }

    private func makeNewTaskRedactorView() -> some View {
        let newTask = Task(title: "", description: "", isDone: false, createdAt: Date())
        return TaskRedactorView(
            taskVM: TaskRedactorViewModel(
                task: newTask,
                isNewTask: true,
                onSave: { [weak viewModel] in
                    viewModel?.loadTasks()
                    refreshID = UUID()
                }
            )
        )
    }
}

#Preview {
    let vm = TaskListViewModel.sampleData()

    TaskListView(viewModel: vm)
}
