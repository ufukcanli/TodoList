//
//  Constants.swift
//  TodoList
//
//  Created by Ufuk Canlı on 30.06.2022.
//

import UIKit

enum SFSymbols {
    static let filter = UIImage(systemName: "line.horizontal.3.decrease.circle")
    static let plus = UIImage(systemName: "plus.circle")
    static let trash = UIImage(systemName: "trash")
    static let checkmark = UIImage(systemName: "checkmark")
    static let save = UIImage(systemName: "square.and.arrow.down")
}

enum TableView {
    static let rowHeight = CGFloat(50)
    static let deleteTitle = "Remove item"
    static let completeTitle = "Mark as complete"
    static let navigationBarTitle = "Todo List"
}

enum Cell {
    static let identifier = "ListItemCell"
    static let sampleTodoName = "Sample Todo"
    static let defaultImageName = "circle"
    static let completedImageName = "checkmark.circle.fill"
    static let imageHeight = CGFloat(37)
    static let imageWidth = CGFloat(38)
    static let padding = CGFloat(16)
}
