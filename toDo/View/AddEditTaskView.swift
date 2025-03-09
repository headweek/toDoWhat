//
//  Untitled.swift
//  toDo
//
//  Created by Salman Abdullayev on 09.03.25.
//

import SwiftUI

struct AddEditTaskView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TaskListViewModel
    var taskToEdit: Task?
    
    @State private var taskTitle = ""
    @State private var taskDescription = ""
    
    init(viewModel: TaskListViewModel, taskToEdit: Task? = nil) {
        self.viewModel = viewModel
        self.taskToEdit = taskToEdit
        _taskTitle = State(initialValue: taskToEdit?.title ?? "")
        _taskDescription = State(initialValue: taskToEdit?.taskDescription ?? "")
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    
                    TextField("", text: $taskTitle)
                        .font(.system(size: 34))
                        .font(.body)
                        .textFieldStyle(.plain)
                        .padding(.vertical, 8)
                }
                
                if let creationDate = taskToEdit?.createdAt {
                    VStack(alignment: .leading, spacing: 4) {
                        
                        Text(creationDate.formatted(date: .abbreviated, time: .shortened))
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    
                    TextEditor(text: $taskDescription)
                        .font(.system(size: 16))
                        .font(.body)
                        .foregroundColor(.white)
                        .background(Color.clear)
                        .frame(minHeight: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.clear, lineWidth: 1)
                        )
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(.yellow)
                        Text("Назад")
                            .font(.system(size: 17))
                            .foregroundStyle(.yellow)
                    })
                }
            }
            .onDisappear {
                saveTask()
            }
        }
    }
    
    private func saveTask() {
        if let taskToEdit = taskToEdit {
            viewModel.updateTask(
                taskToEdit,
                newTitle: taskTitle,
                newDescription: taskDescription
            )
        } else {
            viewModel.addTask(
                title: taskTitle,
                description: taskDescription
            )
        }
    }
}
