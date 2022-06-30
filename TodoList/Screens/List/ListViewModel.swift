//
//  ListViewModel.swift
//  TodoList
//
//  Created by Ufuk Canlı on 30.06.2022.
//

import Combine

final class ListViewModel {
    
    @Published private(set) var list: [TodoItem] = []
    @Published private(set) var ascending = false
        
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
    
    func filterByCreationDate() {
        ascending.toggle()
        reloadDataFromDB()
    }
    
    func toggleTodo(at index: Int) {
        PersistenceManager.shared.toggleTodoItem(list[index]) { success in
            if success {
                // SHOW FEEDBACK TO THE USER
            }
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
    
    private func searchTodos(_ searchText: String) {
        PersistenceManager.shared.fetchTodos(with: searchText, ascending) { [weak self] list in
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
