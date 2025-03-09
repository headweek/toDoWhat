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
            Form {
                Section(header: Text("Основная информация")) {
                    TextField("Название задачи", text: $taskTitle)
                }
                
                Section(header: Text("Описание")) {
                    TextEditor(text: $taskDescription)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle(taskToEdit != nil ? "Редактировать" : "Новая задача")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        saveTask()
                        dismiss()
                    }
                    .disabled(taskTitle.isEmpty)
                }
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
