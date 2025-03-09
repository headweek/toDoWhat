//
//  Untitled.swift
//  toDo
//
//  Created by Salman Abdullayev on 09.03.25.
//

import SwiftUI
import CoreData

class TaskListViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    private let coreDataStack = CoreDataStack.shared
    private let networkManager = NetworkManager.shared
    
    private func saveContext() {
        do {
            try coreDataStack.viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func fetchTasks() -> [Task] {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Task.createdAt, ascending: true)]
        
        do {
            return try coreDataStack.viewContext.fetch(request)
        } catch {
            print("Error fetching tasks: \(error)")
            return []
        }
    }
    
    func shareTask(_ task: Task) {
        let text = "Task: \(task.title ?? "")\nDescription: \(task.taskDescription ?? "")"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
    
    func checkFirstLaunch() {
        guard coreDataStack.isFirstLaunch else { return }
        isLoading = true
        loadFromAPI()
    }
    
    private func loadFromAPI() {
        networkManager.fetchTodos { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let remoteTodos):
                    self?.saveToCoreData(todos: remoteTodos)
                    self?.coreDataStack.isFirstLaunch = false
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                }
                self?.isLoading = false
            }
        }
    }
    
    func deleteTask(_ task: Task) {
        coreDataStack.viewContext.delete(task)
        coreDataStack.saveContext()
    }
    
    func addTask(title: String, description: String) {
        let newTask = Task(context: coreDataStack.viewContext)
        newTask.id = UUID()
        newTask.title = title
        newTask.taskDescription = description
        newTask.isCompleted = false
        newTask.createdAt = Date()
        saveContext()
    }
    
    func updateTask(_ task: Task, newTitle: String, newDescription: String) {
        task.title = newTitle
        task.taskDescription = newDescription
        saveContext()
    }
    
    func toggleTaskCompletion(_ task: Task) {
        task.isCompleted.toggle()
        coreDataStack.saveContext()
    }
    
    private func saveToCoreData(todos: [RemoteTodo]) {
        coreDataStack.viewContext.perform {
            for todo in todos {
                let task = Task(context: self.coreDataStack.viewContext)
                task.id = UUID()
                task.title = todo.todo
                task.isCompleted = todo.completed
                task.createdAt = Date()
                task.userId = Int32(todo.userId)
            }
            self.coreDataStack.saveContext()
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    private let apiUrl = "https://dummyjson.com/todos"
    
    func fetchTodos(completion: @escaping (Result<[RemoteTodo], Error>) -> Void) {
        guard let url = URL(string: apiUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(TodoResponse.self, from: data)
                completion(.success(response.todos))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
