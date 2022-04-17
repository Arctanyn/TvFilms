//
//  SearchViewController.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 16.03.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.tintColor = .label
        controller.searchBar.placeholder = "Search for a movies, TV series or anime"
        controller.hidesNavigationBarDuringPresentation = false
        controller.automaticallyShowsCancelButton = true
        return controller
    }()
    
    //MARK: Properties
    
    private var titles: [TitleModel] = []
    
    //MARK: - View
    
    private lazy var titlesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .orange
        return imageView
    }()
    
    private lazy var searchLabel: UILabel = {
        let label = UILabel()
        label.text = "Write something to get what you are looking for".uppercased()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTableView()
        setConstraints()
        titlesTableView.isHidden = true
    }
    
    //MARK: - Private methods
    
    private func setupNavigationBar() {
        title = "Search"
        navigationController?.navigationBar.tintColor = .label
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonDidTapped))
    }
    
    private func setupTableView() {
        titlesTableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        titlesTableView.delegate = self
        titlesTableView.dataSource = self
    }
    
    private func setConstraints() {
        view.addSubview(searchImageView)
        let searchImageViewConstraints = [
            searchImageView.heightAnchor.constraint(equalToConstant: 60),
            searchImageView.widthAnchor.constraint(equalToConstant: 60),
            searchImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        view.addSubview(searchLabel)
        let searchLabelConstraints = [
            searchLabel.topAnchor.constraint(equalTo: searchImageView.bottomAnchor),
            searchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchLabel.heightAnchor.constraint(equalToConstant: 60),
            searchLabel.widthAnchor.constraint(equalToConstant: 250)
        ]
        
        view.addSubview(titlesTableView)
        let tableViewConstraints = [
            titlesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titlesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titlesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titlesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(searchImageViewConstraints)
        NSLayoutConstraint.activate(searchLabelConstraints)
        NSLayoutConstraint.activate(tableViewConstraints)
    }
    
    //MARK: - Ations
    
    @objc private func closeButtonDidTapped() {
        dismiss(animated: true)
    }
}

//MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        let titleModel = TitleViewModel(of: title)
        cell.configure(with: titleModel)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let titlePageVC = TitlePageViewController()
        titlePageVC.configure(with: titles[indexPath.row])
        titlePageVC.modalPresentationStyle = .fullScreen
        present(titlePageVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
}

//MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty,
              searchText.trimmingCharacters(in: .whitespaces).count >= 3
        else { return }
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
            APICaller.shared.searchTitles(query: searchText) { [weak self] result in
                switch result {
                case .success(let titles):
                    self?.titles = titles.filter {
                        guard ($0.original_name != nil || $0.original_title != nil), $0.poster_path != nil
                        else { return false }
                        return true
                    }
                    DispatchQueue.main.async {
                        self?.titlesTableView.reloadData()
                        self?.titlesTableView.isHidden = false
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let title = titles[indexPath.row]
        return setupTitleContextMenu(title)
    }
}
