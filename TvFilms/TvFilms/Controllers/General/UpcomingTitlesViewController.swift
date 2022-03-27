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
        fetchUpcomingTitles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
    
    private func setupTitlePage(with title: TitleModel) {
        let titlePageVC = TitlePageViewController()
        titlePageVC.configure(with: title)
        titlePageVC.modalPresentationStyle = .fullScreen
        present(titlePageVC, animated: true)
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
        let titlePageVC = TitlePageViewController()
        titlePageVC.configure(with: titles[indexPath.row])
        titlePageVC.modalPresentationStyle = .fullScreen
        present(titlePageVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let title = titles[indexPath.row]
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let addToBookmarks = UIAction(title: "Add to bookmarks", image: UIImage(systemName: "bookmark")) { _ in
                StorageManager.shared.save(title, completion: nil)
            }
            let learnMore = UIAction(title: "Learn more", image: UIImage(systemName: "ellipsis.circle")) { _ in
                Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
                    self?.setupTitlePage(with: title)
                }
            }
            return UIMenu(title: (title.original_name ?? title.original_title) ?? "", image: nil, children: [addToBookmarks, learnMore])
        }
        return configuration
    }
}
