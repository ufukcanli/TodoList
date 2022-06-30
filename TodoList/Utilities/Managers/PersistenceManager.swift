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
        container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data store failed to load: \(error)")
            }
        }
    }
}

extension PersistenceManager {
    
    func createNewTodoItem(completion: @escaping (Bool) -> Void) {
        let newTodoItem = TodoItem(context: container.viewContext)
        newTodoItem.title = "New todo item \(Int.random(in: 0..<100))"
        newTodoItem.completionDate = Date()
        
        do {
            if container.viewContext.hasChanges {
                try container.viewContext.save()
                completion(true)
            }
        } catch {
            debugPrint("UNABLE TO ADD NEW TODO ITEM, \(error)")
            completion(false)
        }
    }
    
    func toggleTodoItem(
        _ item: TodoItem,
        completion: @escaping (Bool) -> Void
    ) {
        do {
            item.isCompleted = !item.isCompleted
            if container.viewContext.hasChanges {
                try container.viewContext.save()
                completion(true)
            }
        } catch {
            debugPrint("UNABLE TO MARK AS COMPLETE, \(error)")
            completion(false)
        }
    }
    
    func deleteTodoItem(
        _ item: TodoItem,
        completion: @escaping (Bool) -> Void
    ) {
        do {
            container.viewContext.delete(item)
            if container.viewContext.hasChanges {
                try container.viewContext.save()
                completion(true)
            }
        } catch {
            debugPrint("UNABLE TO DELETE TODO ITEM, \(error)")
            completion(false)
        }
    }
    
    func fetchTodos(
        with searchText: String? = nil,
        _ ascending: Bool? = nil,
        completion: @escaping ([TodoItem]) -> Void
    ) {
        let fetchRequest: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        if let searchText = searchText {
            fetchRequest.predicate = NSPredicate(
                format: "title CONTAINS[c] %@",
                searchText
            )
        }
        if let ascending = ascending {
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(
                    key: #keyPath(TodoItem.title),
                    ascending: ascending
                )
            ]
        }
        container.viewContext.perform {
            do {
                let todos = try fetchRequest.execute()
                completion(todos)
            } catch {
                print("UNABLE TO EXECUTE FETCH REQUEST, \(error)")
                completion([])
            }
        }
    }
}
