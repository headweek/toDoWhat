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
        VStack(alignment: .leading) {
            HStack {
                Button {
                    viewModel.toggleTaskCompletion(task)
                } label: {
                    Image(task.isCompleted ? "checked" : "check")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(task.isCompleted ? .green : .gray)
                }
                .buttonStyle(PlainButtonStyle())
                VStack(alignment: .leading) {
                    Text(task.title ?? "")
                        .font(.system(size: 16))
                        .font(.headline)
                        .strikethrough(task.isCompleted, color: .gray)
                    if let description = task.taskDescription, !description.isEmpty {
                        Text(description)
                            .font(.system(size: 12))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                    }
                    if let date = task.createdAt {
                        Text(date.formatted(date: .numeric, time: .shortened))
                            .font(.system(size: 12))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}
