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
        static var bacwardButtonColor: Color = .yellow
        static var bacwardButtonImageSize: CGFloat = 20
    }

    // MARK: - Properties
    @State var taskVM: TaskRedactorViewModel
    @Environment(\.dismiss) private var dismiss


    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 8) {
                TextField("Title", text: $taskVM.task.title)
                    .font(.system(.largeTitle, design: .default))
                    .bold()
                    .padding(.horizontal)
                    .padding(.top)
                
                Text(taskVM.task.createdAt.slashedDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                
                TextEditor(text: $taskVM.task.description)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .top)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: Constants.backwardButtonImage)
                                .font(.system(size: Constants.bacwardButtonImageSize, weight: .bold))
                            Text(Constants.bacwardButtonLable)
                        }
                    }
                    .foregroundStyle(Constants.bacwardButtonColor)
                }
            }
        }
    }
}

#Preview {
    TaskRedactorView(taskVM: TaskRedactorViewModel(task: Task(title: "Preview Task", description: "some text")))
}
