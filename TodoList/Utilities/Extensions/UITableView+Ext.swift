//
//  UITableView+Ext.swift
//  TodoList
//
//  Created by Ufuk Canlı on 30.06.2022.
//

import UIKit.UITableView

extension UITableView {
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
