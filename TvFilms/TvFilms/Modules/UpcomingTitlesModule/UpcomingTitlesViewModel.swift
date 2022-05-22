//
//  UpcomingTitlesViewModel.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 22.05.2022.
//

import Foundation

//MARK: - UpcomingTitlesViewModelProtocol

protocol UpcomingTitlesViewModelProtocol: TitleActionsViewModelProtocol {
    var numberOfTitles: Int { get }
    func fetchTitles(completion: @escaping () -> Void)
    func idForTitle(at indexPath: IndexPath) -> Int
    func viewModelForCell(at indexPath: IndexPath) -> TitlePreviewCellViewModelProtocol
    func showTitlePageForCell(at indexPath: IndexPath)
}

//MARK: - UpcomingTitlesViewModel

class UpcomingTitlesViewModel: UpcomingTitlesViewModelProtocol {
    
    //MARK: Properties
    
    var numberOfTitles: Int {
        titles.count
    }
    
    private var titles: [TMDBTitle] = []
    private let apiKeyManager = APIKeyManager()
    private lazy var apiKey = apiKeyManager.getAPIKey(type: .TMDB) ?? ""
    private lazy var dataExtractor = TMDBDataExtractor(apiKey: self.apiKey)
    private let storageManager = StorageManager()
    private let router: Router
    
    //MARK: - Initialization
    
    init(router: Router) {
        self.router = router
    }
    
    //MARK: - Methods
    
    func fetchTitles(completion: @escaping () -> Void) {
        dataExtractor.fetchTitles(category: .upcomingMovies) { [weak self] fetchedTitles in
            guard let fetchedTitles = fetchedTitles else { return }
            self?.titles = fetchedTitles
            completion()
        }
    }
    
    func idForTitle(at indexPath: IndexPath) -> Int {
        titles[indexPath.row].id
    }
    
    func viewModelForCell(at indexPath: IndexPath) -> TitlePreviewCellViewModelProtocol {
        TitlePreviewCellViewModel(title: titles[indexPath.row], apiKey: self.apiKey)
    }
    
    func showTitlePageForCell(at indexPath: IndexPath) {
        router.present(module: .titlePage, animated: true, context: titles[indexPath.row], completion: nil)
    }
}

//MARK: - ViewModelTitleActionsProtocol

extension UpcomingTitlesViewModel: TitleActionsViewModelProtocol {
    func isTitleInStorage(at indexPath: IndexPath) -> Bool {
        storageManager.isInStorage(titles[indexPath.row])
    }
    
    func deleteBookmark(at indexPath: IndexPath) {
        storageManager.delete(titles[indexPath.row])
    }
    
    func addBookmarkForTitle(at indexPath: IndexPath) {
        storageManager.save(titles[indexPath.row])
    }
    
    func learnMoreAboutTitle(at indexPath: IndexPath) {
        router.present(module: .titlePage, animated: true, context: titles[indexPath.row], completion: nil)
    }
}

