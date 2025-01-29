//
//  StudySetApp.swift
//  StudySet
//
//  Created by Niam Bashambu on 9/29/24.
//

import SwiftUI
import CoreData



@main
struct StudySetApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
            
            
            
        }
    }
}
 
class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "QuizDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error)")
            }
        }
    }
}
