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
        completion: @escaping ([TodoItem]) -> Void
    ) {
        let fetchRequest: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        if let searchText = searchText {
            fetchRequest.predicate = NSPredicate(
                format: "title CONTAINS[c] %@",
                searchText
            )
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
    
    func deleteAll(completion: @escaping (NSBatchDeleteResult) -> Void) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TodoItem.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
            completion(delete)
        }
    }
}
