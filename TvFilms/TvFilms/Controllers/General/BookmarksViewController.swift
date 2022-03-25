//
//  BookmarksViewController.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 16.03.2022.
//

import UIKit

class BookmarksViewController: UIViewController {
    
    //MARK: Properties
    
    private var titles: [TitleStorageModel] = [] {
        didSet {
            deleteAllButton.isEnabled = !titles.isEmpty
        }
    }
    
    //MARK: - View
    
    private lazy var bookmarkTitlesTableView = UITableView(frame: .zero, style: .grouped)
    
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
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bookmarkTitlesTableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchStorageData()
    }
    
    //MARK: - Ations
    
    @objc private func deleteAllAction(_ sender: UIBarButtonItem) {
        guard sender == deleteAllButton else { return }
        showDeleteAllAlert()
    }
    
    //MARK: - Private methods
    
    private func setupNavigationBar() {
        title = "Bookmarks"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = deleteAllButton
    }
    
    private func setupTableView() {
        view.addSubview(bookmarkTitlesTableView)
        bookmarkTitlesTableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        bookmarkTitlesTableView.delegate = self
        bookmarkTitlesTableView.dataSource = self
    }
    
    private func fetchStorageData() {
        StorageManager.shared.fetchData { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.bookmarkTitlesTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func deleteBookmark(at indexPath: IndexPath) {
        StorageManager.shared.delete(titles[indexPath.row])
        titles.remove(at: indexPath.row)
        bookmarkTitlesTableView.deleteRows(at: [indexPath], with: .right)
    }
    
    private func deleteAllBookmarks() {
        StorageManager.shared.deleteAll()
        titles.removeAll()
        bookmarkTitlesTableView.reloadData()
    }
    
    private func deleteAction(indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, completion in
            self?.deleteBookmark(at: indexPath)
            completion(true)
        }
        action.image = UIImage(systemName: "trash")
        return action
    }
    
    private func showDeleteAllAlert() {
        let alert = UIAlertController(
            title: "All your bookmarks will be removed from your list",
            message: "This action cannot be undone",
            preferredStyle: .actionSheet
        )
        
        let delete = UIAlertAction(title: "Delete bookmarks", style: .destructive) { [weak self] _ in
            self?.deleteAllBookmarks()
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
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        let titleModel = TitleViewModel(
            name: (title.original_name ?? title.original_title) ?? "",
            overview: title.overview ?? "",
            posterURL: title.poster_path ?? "",
            backgroundPosterPath: title.backdrop_path ?? "",
            voteAverage: title.vote_average,
            mediaType: title.media_type ?? ""
        )
        cell.configure(with: titleModel)
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension BookmarksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let bookmark = titles[indexPath.row]
        let title = TitleModel(
            id: Int(bookmark.id),
            media_type: bookmark.media_type,
            original_name: bookmark.original_name,
            original_title: bookmark.original_title,
            poster_path: bookmark.poster_path,
            backdrop_path: bookmark.backdrop_path,
            overview: bookmark.overview,
            vote_average: bookmark.vote_average,
            release_date: bookmark.release_date
        )
        let titlePageVC = TitlePageViewController()
        titlePageVC.modalPresentationStyle = .fullScreen
        titlePageVC.configure(with: title, canAddBookmarks: false)
        present(titlePageVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let title = titles[indexPath.row]
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let deleteBookmark = UIAction(title: "Delete bookmark", image: UIImage(systemName: "bookmark.slash"), attributes: .destructive) { [weak self] _ in
                self?.deleteBookmark(at: indexPath)
            }
            return UIMenu(title: (title.original_name ?? title.original_title) ?? "", children: [deleteBookmark])
        }
        return configuration
    }
}
