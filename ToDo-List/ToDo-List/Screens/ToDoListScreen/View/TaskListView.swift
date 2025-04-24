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
    @State var searchText: String = ""

    var body: some View {
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
                    }
                }
                .padding()
            }
            .searchable(text: $viewModel.searchText)
            .navigationTitle("Задачи")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }

                ToolbarItem(placement: .bottomBar) {
                    Text("\(viewModel.tasks.count ) Задач")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
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
                    }
                }
            }
        }
    }
}

#Preview {
    let vm = TaskListViewModel.sampleData()

    TaskListView(viewModel: vm, searchText: "")
}
