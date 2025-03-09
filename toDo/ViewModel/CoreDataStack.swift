//
//  Untitled.swift
//  toDo
//
//  Created by Salman Abdullayev on 09.03.25.
//

import SwiftUI
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    private let firstLaunchKey = "isFirstLaunch"
    
    var isFirstLaunch: Bool {
        get { !UserDefaults.standard.bool(forKey: firstLaunchKey) }
        set { UserDefaults.standard.set(!newValue, forKey: firstLaunchKey) }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoApp")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
