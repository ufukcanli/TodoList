//
//  ListViewController.swift
//  TodoList
//
//  Created by Ufuk Canlı on 30.06.2022.
//

import UIKit
import Combine

final class ListViewController: UITableViewController {
    
    lazy var loadingView = UIActivityIndicatorView(style: .large)
    lazy var searchController = UISearchController()
    lazy var emptyStateLabel = UILabel()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let viewModel: ListViewModel!

    init(viewModel: ListViewModel = ListViewModel()) {
        self.viewModel = viewModel
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureLoadingView()
        configureNavigationBar()
        configureSearchController()
        configureEmptyStateLabel()
        
        bindViewModel()
        viewModel.fetchTodos()
    }
}


// MARK: - Helpers
private extension ListViewController {
    
    func bindViewModel() {
        viewModel.$list
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.updateViewController()
            }
            .store(in: &cancellables)
        
        viewModel.$ascending
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.updateViewController()
            }
            .store(in: &cancellables)
    }
    
    func updateViewController() {
        self.loadingView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.loadingView.stopAnimating()
        }
        self.tableView.reloadData()
    }
}


// MARK: - Actions
extension ListViewController {
    
    @objc func filterButtonDidTap() {
        viewModel.filterByTitle()
        configureFilterButton(viewModel.ascending)
    }
    
    @objc func addButtonDidTap() {
        viewModel.addNewTodo()
    }
}


// MARK: - UISearchBarDelegate
extension ListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.fetchTodos(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.fetchTodos()
    }
}


// MARK: - UITableViewDataSource
extension ListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyStateLabel.isHidden = viewModel.shouldShowEmptyState
        return viewModel.numberOfRowsInSection
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListItemViewModel.identifier, for: indexPath) as! ListItemCell
        cell.populateCell(with: ListItemViewModel(todoItem: viewModel.listItem(at: indexPath.row)))
        return cell
    }
}


// MARK: - UITableViewDelegate
extension ListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .normal, title: TableView.completeTitle) { [weak self] _, _, _ in
            guard let self = self else { return }
            self.viewModel.toggleTodo(at: indexPath.row) { _ in
                self.updateViewController()
            }
        }
        completeAction.backgroundColor = viewModel.listItem(at: indexPath.row).isCompleted ? .systemYellow : .systemGreen
        completeAction.image = viewModel.listItem(at: indexPath.row).isCompleted ? SFSymbols.xmark : SFSymbols.checkmark
        return UISwipeActionsConfiguration(actions: [completeAction])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: TableView.deleteTitle) { [weak self] _, _, _ in
            guard let self = self else { return }
            self.viewModel.deleteTodo(at: indexPath.row)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = SFSymbols.trash
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableView.rowHeight
    }
}
