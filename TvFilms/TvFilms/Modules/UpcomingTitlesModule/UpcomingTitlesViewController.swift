//
//  UpcomingTitlesViewController.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 16.03.2022.
//

import UIKit

class UpcomingTitlesViewController: UIViewController {
    
    //MARK: Properties
    
    var viewModel: UpcomingTitlesViewModelProtocol! {
        didSet {
            viewModel.fetchTitles { [unowned self] in
                upcomingTableView.reloadData()
            }
        }
    }
    
    //MARK: - View
    
    private lazy var upcomingTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TitlePreviewTableViewCell.self, forCellReuseIdentifier: TitlePreviewTableViewCell.identifier)
        return tableView
    }()
    
    //MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upcoming"
        navigationController?.navigationBar.setupNavigationBarAppearance()
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func viewDidLayoutSubviews() {
        upcomingTableView.frame = view.bounds
    }
    
    //MARK: - Private methods

    private func setupTableView() {
        view.addSubview(upcomingTableView)
        upcomingTableView.dataSource = self
        upcomingTableView.delegate = self
    }
}

//MARK: - UITableViewDataSource

extension UpcomingTitlesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfTitles
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitlePreviewTableViewCell.identifier, for: indexPath) as? TitlePreviewTableViewCell else {
            return UITableViewCell()
        }
        cell.titleID = self.viewModel.idForTitle(at: indexPath)
        cell.viewModel = self.viewModel.viewModelForCell(at: indexPath)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension UpcomingTitlesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.showTitlePageForCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let titleInteractions = TitleCellContextMenuBuilder(viewModel: self.viewModel)
        return titleInteractions.configureContextMenuForCell(at: indexPath)
    }
}
