//
//  Untitled.swift
//  toDo
//
//  Created by Salman Abdullayev on 09.03.25.
//

import SwiftUI

struct TaskRow: View {
    @ObservedObject var task: Task
    var viewModel: TaskListViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button {
                    viewModel.toggleTaskCompletion(task)
                } label: {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isCompleted ? .green : .gray)
                }
                .buttonStyle(PlainButtonStyle())
                
                Text(task.title ?? "")
                    .font(.headline)
                    .strikethrough(task.isCompleted, color: .gray)
                
                Spacer()
            }
            
            if let description = task.taskDescription, !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            HStack {
                if let date = task.createdAt {
                    Text(date.formatted(date: .numeric, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if task.taskDescription?.isEmpty == false {
                    Image(systemName: "text.alignleft")
                        .foregroundColor(.blue)
                        .font(.caption)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
