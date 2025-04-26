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
    @State private var selectedTask: TaskViewModel? = nil

    @State private var navigationPath = NavigationPath()
    @State private var showShareSheet = false
    @State private var showEditorTask = false

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
            .font(.system(size: 20))
            .foregroundStyle(theme.colors.accent)
    }

    // MARK: - Main View
    var body: some View {
        ZStack {
            NavigationStack(path: $navigationPath) {
                taskListContent
                    .searchable(text: $viewModel.searchText)
                    .navigationTitle("Задачи")
                    .toolbarBackground(theme.colors.secondary.opacity(0.3), for: .bottomBar)
                    .toolbarBackground(.visible, for: .bottomBar)
                    .toolbar { bottomToolbar }
                    .onAppear {
                        viewModel.loadLocalTasks()
                    }
                    .sheet(isPresented: $showShareSheet) {
                        ShareSheet(items: ["\(selectedTask?.task.title ?? "")\n \(selectedTask?.task.description ?? "")"])
                    }
                    .fullScreenCover(isPresented: $showEditorTask) {
                        if let task = selectedTask {
                            TaskRedactorView(
                                taskVM: TaskRedactorViewModel(task: task.task)
                            )
                            .onDisappear() {
                                showEditorTask = false
                                viewModel.loadLocalTasks()
                                closeDialog()
                            }
                        }
                    }
            }
            .blur(radius: selectedTask == nil ? 0 : 4)
            
            if let selectedTask {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture { closeDialog() }

                VStack(spacing: 16) {
                    TaskView(viewModel: selectedTask)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(theme.colors.background)
                        .cornerRadius(16)
                        .padding(.horizontal, 32)
                        .scaleEffect(1.05)
                        .shadow(radius: 10)

                    actionMenu(for: selectedTask)
                }
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
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
                .contentShape(Rectangle())
                .simultaneousGesture(
                    LongPressGesture()
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                print(viewModel.task.title)
                                selectedTask = viewModel
                            }
                        }
                )
        }
        .buttonStyle(.plain)
    }

    func closeDialog() {
        selectedTask = nil
    }

    func editTask(_ task: TaskViewModel) {
        showEditorTask = true
        selectedTask = task
    }

    func shareTask(_ task: TaskViewModel) {
        showShareSheet = true
    }

    func deleteTask(_ task: TaskViewModel) {
        closeDialog()
        viewModel.deleteTask(task)
        task.onDelete()
    }


    // MARK: - View Components
    @ViewBuilder
    private func actionMenu(for task: TaskViewModel) -> some View {
        VStack(spacing: 0) {
            Button(action: { editTask(task) }) {
                menuButton(title: "Редактировать", icon: "square.and.pencil")
            }

            Divider()

            Button(action: { shareTask(task) }) {
                menuButton(title: "Поделиться", icon: "square.and.arrow.up")
            }

            Divider()

            Button(action: { deleteTask(task) }) {
                menuButton(title: "Удалить", icon: "trash", color: .red)
            }
        }
        .background(.ultraThinMaterial)
        .foregroundStyle(theme.colors.secondary)
        .cornerRadius(12)
        .padding(.horizontal, 40)
    }

    @ViewBuilder
    private func menuButton(title: String, icon: String, color: Color = .primary) -> some View {
        HStack {
            Text(title)
                .foregroundColor(color)
            Spacer()
            Image(systemName: icon)
                .foregroundColor(color)
        }
        .padding()
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
