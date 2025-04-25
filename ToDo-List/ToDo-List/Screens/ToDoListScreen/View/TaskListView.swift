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
//    @StateObject private var viewModel = TaskListViewModel()
    @ObservedObject var viewModel: TaskListViewModel

    @Environment(\.colorScheme) var colorScheme


    var body: some View {
        let theme = AppTheme.theme(for: colorScheme)
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.filteredTasks) { vm in
                        NavigationLink {
                            TaskRedactorView(taskVM: TaskRedactorViewModel(task: vm.task))
                        } label: {
                            TaskView(viewModel: vm)
                        }
                        .buttonStyle(.plain)

                        Divider()
                            .background(theme.colors.secondary)
                            .padding(.horizontal)
                    }
                }
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
                    Text("\(viewModel.tasks.count ) Задач")
                        .font(theme.fonts.subheadline)
                        .foregroundColor(theme.colors.text)
                }

                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }

                ToolbarItem(placement: .bottomBar) {
                    Button {
                        print("добавить")
                    } label: {
                        Image(systemName: Constants.addNewToDoButtonImage)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(theme.colors.accent)
                    }
                }
            }
        }
    }
}

#Preview {
    let vm = TaskListViewModel.sampleData()

    TaskListView(viewModel: vm)
}
