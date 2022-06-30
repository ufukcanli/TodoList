//
//  ListItemViewModel.swift
//  TodoList
//
//  Created by Ufuk Canlı on 30.06.2022.
//

import Foundation

final class ListItemViewModel {
    
    static let identifier = Cell.identifier
    
    private(set) var imageName = Cell.defaultImageName
    private(set) var todoTitle = Cell.sampleTodoName
    
    private let todoItem: TodoItem!
    
    init(todoItem: TodoItem) {
        self.todoItem = todoItem
        checkTodoItem()
    }
    
    func checkTodoItem() {
        if todoItem.isCompleted {
            imageName = Cell.completedImageName
        } else {
            imageName = Cell.defaultImageName
        }
        
        if let title = todoItem.title {
            todoTitle = title
        }
    }
}
