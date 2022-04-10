//
//  HomeViewController.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 16.03.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    enum TitlesGroup: Int, CaseIterable {
        case popular
        case trendingTVs
        case trendingAnime
        case trendingMovies
        case trendingAnimeMovies
        case topRated
    }
    
    //MARK: Properties
    
    private var sourceURLs = SourceURL()
    
    private let titlesGroupsNames: [TitlesGroup: String] = [
        .popular: "Popular",
        .trendingAnime: "Trending Anime",
        .trendingMovies: "Trending movies",
        .trendingTVs: "Trending TV",
        .trendingAnimeMovies: "Trending Anime Movies",
        .topRated: "Top rated",
    ]
    
    private var headerTitle: TitleModel?
    
    //MARK: - View
    
    private lazy var titlesCollectionTableView = UITableView(frame: .zero, style: .insetGrouped)
    private var headerView: HeaderCoverView?
    private lazy var titlesRefreshControl: UIRefreshControl = {
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(refreshTitles(_:)), for: .valueChanged)
        refreshControll.tintColor = .systemOrange
        return refreshControll
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
        titlesCollectionTableView.frame = view.bounds
    }
    
    //MARK: - Private methods
    
    private func presentTitlePage(_ title: TitleModel) {
        let titlePageVC = TitlePageViewController()
        titlePageVC.configure(with: title)
        titlePageVC.modalPresentationStyle = .fullScreen
        present(titlePageVC, animated: true)
    }
    
    private func setupNavigationBar() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(goToSearch))
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
        titlesCollectionTableView.register(TitleCollectionTableViewCell.self, forCellReuseIdentifier: TitleCollectionTableViewCell.identifier)
        titlesCollectionTableView.delegate = self
        titlesCollectionTableView.dataSource = self
        titlesCollectionTableView.backgroundColor = .systemBackground
        headerView = HeaderCoverView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        setupHeaderView()
        titlesCollectionTableView.tableHeaderView = headerView
        titlesCollectionTableView.refreshControl = titlesRefreshControl
    }
    
    private func setupHeaderView() {
        let titlesURLs = [
            sourceURLs.trendingTVs,
            sourceURLs.trendingMovies,
            sourceURLs.popularAnimeMovies,
            sourceURLs.popularAnimeTVs
        ]
        let url = titlesURLs.randomElement()!
        APICaller.shared.getTitles(from: url) { [weak self] result in
            switch result {
            case .success(let titles):
                let title = titles.randomElement()
                if let title = title {
                    self?.headerTitle = title
                    let titleModel = TitleViewModel(of: title)
                    self?.headerView?.configure(with: titleModel)
                    self?.headerView?.delegate = self
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Ations
    
    @objc private func goToSearch() {
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.modalPresentationStyle = .fullScreen
        present(searchVC, animated: true)
    }
    
    @objc private func refreshTitles(_ sender: UIRefreshControl) {
        titlesCollectionTableView.reloadData()
        setupHeaderView()
        titlesCollectionTableView.tableHeaderView = headerView
        sender.endRefreshing()
    }
}

//MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return titlesGroupsNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleCollectionTableViewCell.identifier, for: indexPath) as? TitleCollectionTableViewCell else {
            return UITableViewCell()
        }
        
        var titlesURL = ""
        
        switch indexPath.section {
        case TitlesGroup.popular.rawValue:
            titlesURL = sourceURLs.popular
        case TitlesGroup.trendingAnime.rawValue:
            titlesURL = sourceURLs.popularAnimeTVs
        case TitlesGroup.trendingAnimeMovies.rawValue:
            titlesURL = sourceURLs.popularAnimeMovies
        case TitlesGroup.trendingMovies.rawValue:
            titlesURL = sourceURLs.trendingMovies
        case TitlesGroup.trendingTVs.rawValue:
            titlesURL = sourceURLs.trendingTVs
        case TitlesGroup.topRated.rawValue:
            titlesURL = sourceURLs.topRated
        default:
            print("ATTENTION: The index is placed outside the index of groups")
            break
        }
        
        if !titlesURL.isEmpty {
            APICaller.shared.getTitles(from: titlesURL) { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        cell.delegate = self
        return cell
    }
}

//MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let currentGroup = TitlesGroup.allCases[section]
        guard let groupName = titlesGroupsNames[currentGroup] else { return nil }
        
        let label = UILabel()
        label.text = groupName.uppercased()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .label
        
        return label
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - TitleCollectionTableViewCellDelegate

extension HomeViewController: TitleCollectionTableViewCellDelegate {
    func cellDidSelect(with title: TitleModel) {
        presentTitlePage(title)
    }
}

//MARK: - HeaderCoverViewDelegate

extension HomeViewController: HeaderCoverViewDelegate {
    func learnMoreAbout(title: TitleViewModel) {
        guard let title = headerTitle else { return }
        presentTitlePage(title)
    }
}
