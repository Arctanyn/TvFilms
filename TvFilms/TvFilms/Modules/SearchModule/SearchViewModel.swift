//
//  SearchViewModel.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 20.05.2022.
//

import Foundation

//MARK: - SearchViewModelProtocol

protocol SearchViewModelProtocol {
    var numberOfResults: Int { get }
    func searchTitle(query: String, completion: @escaping () -> Void)
    func createSearchResultViewModel() -> TitleSearchResultViewModelProtocol
    func closeSearch()
}

//MARK: - SearchViewModelDelegate

protocol SearchViewModelDelegate: AnyObject {
    func showTitlePage(with title: TMDBTitle)
}

//MARK: - SearchViewModel

class SearchViewModel: SearchViewModelProtocol, SearchViewModelDelegate {
    var numberOfResults: Int {
        titles.count
    }
    
    private var titles: [TMDBTitle] = []
    private lazy var apiKey = APIKeyManager().getAPIKey(type: .TMDB) ?? ""
    private lazy var apiDataExtractor = TMDBDataExtractor(apiKey: apiKey)
    private let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    //MARK: - Methods
    
    func searchTitle(query: String, completion: @escaping () -> Void) {
        apiDataExtractor.searchTitles(query: query) { [weak self] fetchedTitles in
            guard let fetchedTitles = fetchedTitles else { return }
            self?.titles = fetchedTitles
            completion()
        }
    }
    
    func createSearchResultViewModel() -> TitleSearchResultViewModelProtocol {
        let viewModel = TitleSearchResultViewModel(titles: self.titles, apiKey: self.apiKey)
        viewModel.delegate = self
        return viewModel
    }
    
    func closeSearch() {
        router.dismiss(animated: true, completion: nil)
    }
    
    func showTitlePage(with title: TMDBTitle) {
        router.present(module: .titlePage, animated: true, context: title, completion: nil)
    }
}
