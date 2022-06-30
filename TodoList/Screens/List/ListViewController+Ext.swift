//
//  ListViewController+Ext.swift
//  TodoList
//
//  Created by Ufuk Canlı on 30.06.2022.
//

import UIKit

// MARK: - Configure UI
extension ListViewController {
    
    func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        title = TableView.navigationBarTitle
        configureFilterButton()
        configureAddButton()
    }
    
    func configureTableView() {
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        tableView.register(ListItemCell.self, forCellReuseIdentifier: ListItemViewModel.identifier)
    }
    
    func configureFilterButton() {
        let filterButton = UIBarButtonItem(
            image: SFSymbols.filter,
            style: .plain,
            target: self,
            action: #selector(filterButtonDidTap)
        )
        navigationItem.leftBarButtonItem = filterButton
    }
    
    func configureAddButton() {
        let addButton = UIBarButtonItem(
            image: SFSymbols.plus,
            style: .plain,
            target: self,
            action: #selector(addButtonDidTap)
        )
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a todo item"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func configureEmptyStateLabel() {
        tableView.addSubview(emptyStateLabel)
        
        let emptyStateText = """
                             🧐 Looks like you don't have
                                   anything to do yet!
                             """
        
        emptyStateLabel.text = emptyStateText
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.font = UIFont.preferredFont(forTextStyle: .body)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyStateLabel.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 100),
            emptyStateLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
        ])
    }
}
