//
//  TitleSearchResultController.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 21.05.2022.
//

import UIKit

class TitleSearchResultController: UIViewController {
    
    //MARK: Properties
    
    var viewModel: TitleSearchResultViewModelProtocol! {
        didSet {
            if viewModel != nil {
                foundTitlesTableView.reloadData()
            }
        }
    }
    
    //MARK: - View
    
    private lazy var foundTitlesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TitlePreviewTableViewCell.self, forCellReuseIdentifier: TitlePreviewTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel = nil
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        foundTitlesTableView.frame = view.bounds
    }
    
    //MARK: - Private methods
    
    private func setupTableView() {
        view.addSubview(foundTitlesTableView)
        foundTitlesTableView.dataSource = self
        foundTitlesTableView.delegate = self
    }

}

//MARK: - UITableViewDataSource

extension TitleSearchResultController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewModel = viewModel {
            return viewModel.resultCount
        } else {
            return 0
        }
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

extension TitleSearchResultController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.showTitlePageForCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let titleInteractions = TitleCellContextMenuBuilder(viewModel: self.viewModel)
        return titleInteractions.configureContextMenuForCell(at: indexPath)
    }
}
