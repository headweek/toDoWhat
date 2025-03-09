//
//  Untitled.swift
//  toDo
//
//  Created by Salman Abdullayev on 09.03.25.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var viewModel: TaskListViewModel
    @Binding var searchText: String
    
    var body: some View {
        List {
            ForEach(filteredTasks) { task in
                TaskRow(task: task, viewModel: viewModel)
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.deleteTask(task)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
        .searchable(text: $searchText)
    }
    
    private var filteredTasks: [Task] {
        let allTasks = viewModel.fetchTasks()
        if searchText.isEmpty {
            return allTasks
        }
        return allTasks.filter {
            $0.title?.lowercased().contains(searchText.lowercased()) ?? false
        }
    }
}
