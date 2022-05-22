//
//  HomeViewController.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 16.03.2022.
//

import UIKit

class HomePageViewController: UIViewController {
    
    //MARK: Properties
    
    var viewModel: HomePageViewModelProtocol!
    
    //MARK: - View
    
    private lazy var titlesCollectionTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private lazy var headerView: UIView = {
        let someView = TitlesHeaderView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.bounds.width,
                height: view.bounds.height * 0.62
            )
        )
        someView.viewModel = self.viewModel.viewModelForHeaderCoverView()
        return someView
    }()

    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        titlesCollectionTableView.frame = view.bounds
    }
    
    //MARK: - Private methods
    
    private func setupNavigationBar() {
        let searchButton = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(goToSearch)
        )
        searchButton.tintColor = .label
        
        let label = UILabel()
        label.text = "TvFilms"
        label.textColor = .orange
        label.font = .systemFont(ofSize: 25, weight: .heavy)
        
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
    }

    private func setupTableView() {
        view.addSubview(titlesCollectionTableView)
        titlesCollectionTableView.delegate = self
        titlesCollectionTableView.dataSource = self
        titlesCollectionTableView.backgroundColor = .systemBackground
        titlesCollectionTableView.tableHeaderView = headerView
    }
    
    //MARK: - Ations
    
    @objc private func goToSearch() {
        viewModel.goToSearch()
    }
}

//MARK: - UITableViewDataSource

extension HomePageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TitleGroupCell()
        cell.viewModel = self.viewModel.viewModelForCell(at: indexPath.section)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension HomePageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = viewModel.titleForCell(at: section)
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .label
        return label
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

