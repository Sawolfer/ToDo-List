//
//  ToDoListView.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 19.04.2025.
//

import SwiftUI


struct ToDoListView: View {
    // MARK: - Constants
    private enum Constants {
        static let addNewToDoButtonImage: String = "square.and.pencil"
    }

    // MARK: - Properties
    @State var tasks: [TaskViewModel]
    @State var searchText: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(tasks, id: \.id) { vm in
                        TaskView(viewModel: vm)
                    }
                }
                .padding()
            }
            .searchable(text: $searchText)
            .navigationTitle("Задачи")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }

                ToolbarItem(placement: .bottomBar) {
                    Text("\(tasks.count) Задач")
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
    ToDoListView(tasks: [
        TaskViewModel(task: Task(title: "Buy milk", description: "From the supermarket")),
        TaskViewModel(task: Task(title: "Do homework", description: "Math exercises", isDone: true))],
                 searchText: "")
}
