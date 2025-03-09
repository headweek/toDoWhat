//
//  Untitled.swift
//  toDo
//
//  Created by Salman Abdullayev on 09.03.25.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TaskListViewModel
    @State private var taskTitle = ""
    @State private var taskDescription = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Task title", text: $taskTitle)
                TextField("Task Discription", text: $taskDescription)
            }
            
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.addTask(title: taskTitle, description: taskDescription)
                        dismiss()
                    }
                    .disabled(taskTitle.isEmpty)
                }
            }
        }
    }
}
