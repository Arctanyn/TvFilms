//
//  SearchViewController.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 16.03.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: Properties
    
    var viewModel: SearchViewModelProtocol!
    
    //MARK: - View
    
    private lazy var titlesSearchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: TitleSearchResultController())
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a films, TV or anime"
        searchController.searchBar.tintColor = .label
        return searchController
    }()
    
    private lazy var magnifyingglassImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 80, height: 80)))
        imageView.image = UIImage(
            systemName: "magnifyingglass",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 45)
        )
        imageView.tintColor = .orange
        return imageView
    }()
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(magnifyingglassImageView)
        setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        magnifyingglassImageView.center = view.center
    }
    
    //MARK: - Ations
    
    @objc private func closeButtonTapped() {
        viewModel.closeSearch()
    }
    
    //MARK: - Private methods
    
    private func setupNavigationBar() {
        title = "Search"
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.setupNavigationBarAppearance()
        setupNavigationBarItems()
        setupSearchBar()
    }
    
    private func setupNavigationBarItems() {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22)), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = titlesSearchController
        titlesSearchController.searchBar.delegate = self
    }
}

//MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard
            !searchText.trimmingCharacters(in: .whitespaces).isEmpty,
            searchText.trimmingCharacters(in: .whitespaces).count >= 3
        else { return }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            self?.viewModel.searchTitle(query: searchText) { [weak self] in
                guard let titleSearchResultVC = self?.titlesSearchController.searchResultsController as? TitleSearchResultController else { return }
                titleSearchResultVC.viewModel = self?.viewModel.createSearchResultViewModel()
            }
        }
    }
}
