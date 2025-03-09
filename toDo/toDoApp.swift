//
//  toDoApp.swift
//  toDo
//
//  Created by Salman Abdullayev on 09.03.25.
//

import SwiftUI

@main
struct todoAppApp: App {
    let coreDataStack = CoreDataStack.shared
    
    init() {
        UIView.appearance().overrideUserInterfaceStyle = .dark
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataStack.viewContext)
        }
    }
}
