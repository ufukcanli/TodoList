//
//  ListItemCell.swift
//  TodoList
//
//  Created by Ufuk Canlı on 30.06.2022.
//

import UIKit

final class ListItemCell: UITableViewCell {
        
    private lazy var completeImageView = UIImageView()
    private lazy var todoTitleLabel = UILabel()
        
    private var viewModel: ListItemViewModel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCompleteImageView()
        configureTodoTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populateCell(with viewModel: ListItemViewModel) {
        self.viewModel = viewModel
        todoTitleLabel.text = viewModel.todoTitle
        completeImageView.image = UIImage(systemName: viewModel.imageName)
    }
}

// MARK: - Configure UI
private extension ListItemCell {
    
    func configureTodoTitleLabel() {
        todoTitleLabel.textColor = .label
        todoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(todoTitleLabel)

        NSLayoutConstraint.activate([
            todoTitleLabel.leadingAnchor.constraint(equalTo: completeImageView.trailingAnchor, constant: Cell.padding),
            todoTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            todoTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            todoTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureCompleteImageView() {
        completeImageView.tintColor = .systemBlue
        completeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(completeImageView)
        
        NSLayoutConstraint.activate([
            completeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Cell.padding),
            completeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Cell.padding / 2),

            completeImageView.heightAnchor.constraint(equalToConstant: Cell.imageHeight),
            completeImageView.widthAnchor.constraint(equalToConstant: Cell.imageWidth),
        ])
    }
}
