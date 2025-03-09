//
//  ContentView.swift
//  toDo
//
//  Created by Salman Abdullayev on 09.03.25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = TaskListViewModel()
    @State private var searchText = ""
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.createdAt, ascending: true)],
        animation: .default
    ) var tasks: FetchedResults<Task>

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredTasks) { task in
                    NavigationLink(destination: AddEditTaskView(viewModel: viewModel, taskToEdit: task)) {
                        TaskRow(task: task, viewModel: viewModel)
                    }
                    .contextMenu {
                        Button("Delete") {
                            viewModel.deleteTask(task)
                        }
                        Button("Share") {
                            viewModel.shareTask(task)
                        }
                    }
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
            .navigationTitle("Todo List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddEditTaskView(viewModel: viewModel)) {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") { }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
        .onAppear(perform: viewModel.checkFirstLaunch)
    }
    
    private var filteredTasks: [Task] {
        if searchText.isEmpty {
            return Array(tasks)
        }
        return tasks.filter {
            $0.title?.lowercased().contains(searchText.lowercased()) ?? false
        }
    }
}
