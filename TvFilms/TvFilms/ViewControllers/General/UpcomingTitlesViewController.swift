//
//  UpcomingTitlesViewController.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 16.03.2022.
//

import UIKit

class UpcomingTitlesViewController: UIViewController {
    
    //MARK: Properties
    
    private var titles: [TitleModel] = []
    private var sourceURLs = SourceURL()
    
    //MARK: - View
    
    private lazy var upcomingTableView = UITableView(frame: .zero, style: .grouped)
    
    //MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if titles.isEmpty {
            fetchUpcomingTitles()
        }
    }
    
    override func viewDidLayoutSubviews() {
        upcomingTableView.frame = view.bounds
    }
    
    //MARK: - Private methods

    private func setupTableView() {
        view.addSubview(upcomingTableView)
        upcomingTableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        upcomingTableView.dataSource = self
        upcomingTableView.delegate = self
    }
    
    private func fetchUpcomingTitles() {
        APICaller.shared.getTitles(from: sourceURLs.upcoming) { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - UITableViewDataSource

extension UpcomingTitlesViewController: UITableViewDataSource {
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

extension UpcomingTitlesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentTitlePage(with: titles[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let title = titles[indexPath.row]
        return setupTitleContextMenu(title)
    }
}
