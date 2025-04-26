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
    @State private var refreshID: UUID = UUID()

    // MARK: - Computed Properties
    private var theme: AppTheme {
        AppTheme.theme(for: colorScheme)
    }

    private var taskCountText: some View {
        Text("\(viewModel.tasks.count) Задач")
            .font(theme.fonts.subheadline)
            .foregroundColor(theme.colors.text)
    }

    private var addButton: some View {
        Image(systemName: Constants.addNewToDoButtonImage)
            .font(.system(size: 20, weight: .bold))
            .foregroundStyle(theme.colors.accent)
    }

    // MARK: - Main View
    var body: some View {
        NavigationStack {
            taskListContent
                .searchable(text: $viewModel.searchText)
                .navigationTitle("Задачи")
                .toolbarBackground(theme.colors.secondary.opacity(0.3), for: .bottomBar)
                .toolbarBackground(.visible, for: .bottomBar)
                .toolbar { bottomToolbar }
                .onAppear {
                    viewModel.loadLocalTasks()
                }
        }
    }

    // MARK: - Subviews
    private var taskListContent: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.filteredTasks) { taskViewModel in
                    taskRow(for: taskViewModel)
                    divider
                }
            }
            .id(refreshID)
        }
    }

    private func taskRow(for viewModel: TaskViewModel) -> some View {
        NavigationLink {
            TaskRedactorView(
                taskVM: taskRedactorViewModel(for: viewModel.task)
            )
        } label: {
            TaskView(viewModel: viewModel)
        }
        .buttonStyle(.plain)
    }

    private var divider: some View {
        Divider()
            .background(theme.colors.secondary)
            .padding(.horizontal)
    }

    private var bottomToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            Spacer()
            taskCountText
            Spacer()
            NavigationLink {
                newTaskRedactorView
            } label: {
                addButton
            }
        }
    }

    // MARK: - View Models
    private func taskRedactorViewModel(for task: Task) -> TaskRedactorViewModel {
        TaskRedactorViewModel(
            task: task,
            onSave: { [weak viewModel] in
                viewModel?.loadLocalTasks()
                refreshID = UUID()
            }
        )
    }

    private var newTaskRedactorView: some View {
        let newTask = Task(title: "", description: "", isDone: false, createdAt: Date())
        return TaskRedactorView(
            taskVM: TaskRedactorViewModel(
                task: newTask,
                isNewTask: true,
                onSave: { [weak viewModel] in
                    viewModel?.loadLocalTasks()
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
