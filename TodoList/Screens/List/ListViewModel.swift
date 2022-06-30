//
//  ListViewModel.swift
//  TodoList
//
//  Created by Ufuk Canlı on 30.06.2022.
//

import Combine

final class ListViewModel: ObservableObject {
    
    @Published private(set) var list: [TodoItem] = []
        
    var numberOfRowsInSection: Int {
        return list.count
    }
    
    var shouldShowEmptyState: Bool {
        if list.count > 0 { return true }
        return false
    }
    
    func listItem(at index: Int) -> TodoItem {
        return list[index]
    }
    
    func toggleTodo(at index: Int, completion: @escaping (Bool) -> Void) {
        PersistenceManager.shared.toggleTodoItem(list[index]) { success in
            completion(success)
        }
    }
    
    func addNewTodo() {
        PersistenceManager.shared.createNewTodoItem { [weak self] success in
            guard let self = self else { return }
            if success { self.reloadDataFromDB() }
        }
    }
    
    func deleteTodo(at index: Int) {
        PersistenceManager.shared.deleteTodoItem(list[index]) { [weak self] success in
            guard let self = self else { return }
            if success { self.reloadDataFromDB() }
        }
    }
    
    func fetchTodos(with searchText: String = "") {
        if !searchText.isEmpty {
            searchTodos(searchText)
        } else {
            fetchTodos()
        }
    }
    
    func deleteAll() {
        PersistenceManager.shared.deleteAll { [weak self] _ in
            guard let self = self else { return }
            self.list = []
        }
    }
    
    private func searchTodos(_ searchText: String) {
        PersistenceManager.shared.fetchTodos(with: searchText) { [weak self] list in
            guard let self = self else { return }
            self.list = list
        }
    }
    
    private func fetchTodos() {
        PersistenceManager.shared.fetchTodos { [weak self] list in
            guard let self = self else { return }
            self.list = list
        }
    }
        
    private func reloadDataFromDB() {
        list = []
        fetchTodos()
    }
}
