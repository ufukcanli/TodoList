//
//  PersistenceManager.swift
//  TodoList
//
//  Created by Ufuk Canlı on 30.06.2022.
//

import CoreData

final class PersistenceManager {
    
    static let shared = PersistenceManager()
        
    let container: NSPersistentContainer
        
    private init() {
        container = NSPersistentContainer(name: "TodoList")
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data store failed to load: \(error)")
            }
        }
    }
}
