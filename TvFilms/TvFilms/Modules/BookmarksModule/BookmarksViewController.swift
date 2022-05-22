//
//  BookmarksViewController.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 16.03.2022.
//

import UIKit

class BookmarksViewController: UIViewController {
    
    //MARK: Properties
    
    var viewModel: BookmarksViewModelProtocol! {
        didSet {
            viewModel.viewModelDidChange = { [unowned self] changedViewModel in
                setEnablingToDeleteAllButton()
            }
        }
    }
    
    private var tableViewCellHeight: CGFloat?
    
    //MARK: - View
    
    private lazy var bookmarksTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: BookmarkTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var deleteAllButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "Delete all",
            style: .plain,
            target: self,
            action: #selector(deleteAllAction(_:))
        )
        button.tintColor = .systemRed
        return button
    }()
    
    //MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableViewCellHeight = view.frame.height * 0.25
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        bookmarksTableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let viewModel = viewModel {
            viewModel.fetchTitles { [unowned self] in
                bookmarksTableView.reloadData()
            }
        }
    }
    
    //MARK: - Ations
    
    @objc private func deleteAllAction(_ sender: UIBarButtonItem) {
        guard sender == deleteAllButton else { return }
        showDeleteAllAlert()
    }
    
    //MARK: - Private methods
    
    private func setupNavigationBar() {
        title = "Bookmarks"
        navigationItem.leftBarButtonItem = deleteAllButton
        navigationController?.navigationBar.setupNavigationBarAppearance()
    }
    
    private func setupTableView() {
        view.addSubview(bookmarksTableView)
        bookmarksTableView.delegate = self
        bookmarksTableView.dataSource = self
    }
    
    private func setEnablingToDeleteAllButton() {
        deleteAllButton.isEnabled = viewModel.numberOfTitles > 0
    }
    
    private func deleteBookmark(at indexPath: IndexPath) {
        viewModel.deleteBookmark(at: indexPath) { [weak self] in
            self?.bookmarksTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    private func showDeleteAllAlert() {
        let alert = UIAlertController(
            title: "All your bookmarks will be removed from your list",
            message: "This action cannot be undone",
            preferredStyle: .actionSheet
        )
        
        let delete = UIAlertAction(title: "Delete bookmarks", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteAllBookmarks {
                self?.bookmarksTableView.reloadData()
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}

//MARK: - UITableViewDataSource

extension BookmarksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfTitles
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkTableViewCell.identifier, for: indexPath) as? BookmarkTableViewCell else {
            return UITableViewCell()
        }
        cell.titleID = viewModel.idForTitle(at: indexPath)
        cell.viewModel = self.viewModel.viewModelForCell(at: indexPath)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension BookmarksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewCellHeight ?? 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.showTitlePageForCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    private func deleteAction(indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, completion in
            self?.deleteBookmark(at: indexPath)
            completion(true)
        }
        action.image = UIImage(systemName: "trash")
        return action
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let titleActions = TitleCellActionsBuilder()
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let delete = titleActions.createDeleteAction { [weak self] in
                self?.deleteBookmark(at: indexPath)
            }
            return UIMenu(title: "", children: [delete])
        }
        
        return configuration
    }
    
}
