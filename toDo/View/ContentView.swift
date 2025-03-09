//
//  ContentView.swift
//  toDo
//
//  Created by Salman Abdullayev on 09.03.25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = TaskListViewModel()
    @State private var searchText = ""
    @State private var selectedTask: Task?
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.createdAt, ascending: true)],
        animation: .default
    ) var tasks: FetchedResults<Task>

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(filteredTasks) { task in
                        TaskRow(task: task, viewModel: viewModel)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedTask = task
                            }
                            .contextMenu {
                                Button(action: {
                                    selectedTask = task
                                }) {
                                      Text("Редактировать")
                                      Image(systemName: "pencil")
                                }
                                Button(action: {
                                    viewModel.shareTask(task)
                                }) {
                                      Text("Поделиться")
                                      Image(systemName: "square.and.arrow.up")
                                }
                                Button(action: {
                                    viewModel.deleteTask(task)
                                }) {
                                      Text("Удалить")
                                        .foregroundColor(Color.red)
                                      Image(systemName: "trash")
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
                .background(Color.black)
                .searchable(text: $searchText)
                .padding(.bottom, 60)
                .navigationTitle("Задачи")
                .navigationDestination(item: $selectedTask) { task in
                    AddEditTaskView(viewModel: viewModel, taskToEdit: task).navigationBarBackButtonHidden(true)
                }
                HStack {
                    Spacer()
                    Text("\(tasks.count) Задач")
                        .font(.system(size: 11))
                        .padding(.leading, 40)
                    Spacer()
                    NavigationLink {
                        AddEditTaskView(viewModel: viewModel).navigationBarBackButtonHidden(true)
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .frame(width: 24, height: 24)
                            .font(.title)
                            .foregroundColor(.yellow)
                            .padding(.bottom)
                    }
                    .padding(.trailing, 20)
                }
            }
            .background(Color.darkGray)
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

