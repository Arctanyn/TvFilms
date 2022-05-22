//
//  TitlesGroupCellViewModel.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 09.05.2022.
//

import Foundation

//MARK: - TitlesGroupCellViewModelProtocol

protocol TitlesGroupCellViewModelProtocol: TitleActionsViewModelProtocol {
    var numberOfTitles: Int { get }
    func fetchTitles(completion: @escaping () -> Void)
    func viewModelForCell(at indexPath: IndexPath) -> TitlesListCellViewModelProtocol
    func titleIDForCell(at indexPath: IndexPath) -> Int
    func titleModelForCell(at indexPath: IndexPath) -> TMDBTitle
    func showTitlePage(for indexPath: IndexPath)
}

//MARK: - TitlesGroupCellViewModel

class TitlesGroupCellViewModel: TitlesGroupCellViewModelProtocol {
    
    //MARK: Properties
    
    var numberOfTitles: Int {
        titles.count
    }
    
    weak var delegate: ViewModelRouteDelegate?
    
    private let titlesCategory: TitlesCategory
    private var titles: [TMDBTitle] = []
    private let apiKeyManager = APIKeyManager()
    private lazy var apiKey = getAPIKey()
    private lazy var apiDataExtractor = TMDBDataExtractor(apiKey: apiKey ?? "")
    private let storageManager = StorageManager()
    
    //MARK: - Initialization
    
    init(titlesCategory: TitlesCategory) {
        self.titlesCategory = titlesCategory
    }
    
    //MARK: - Methods
    
    func fetchTitles(completion: @escaping () -> Void) {
        apiDataExtractor.fetchTitles(category: titlesCategory) { [weak self] fetchedTitles in
            guard let fetchedTitles = fetchedTitles else { return }
            self?.titles = fetchedTitles
            completion()
        }
    }
    
    func viewModelForCell(at indexPath: IndexPath) -> TitlesListCellViewModelProtocol {
        return TitlesListCellViewModel(
            title: titles[indexPath.item],
            apiKey: self.apiKey ?? ""
        )
    }
    
    func titleIDForCell(at indexPath: IndexPath) -> Int {
        return titles[indexPath.row].id
    }
    
    func titleModelForCell(at indexPath: IndexPath) -> TMDBTitle {
        return titles[indexPath.item]
    }
    
    func showTitlePage(for indexPath: IndexPath) {
        delegate?.showTitlePage(with: titles[indexPath.item])
    }
    
    //MARK: - Private methods
    
    private func getAPIKey() -> String? {
        apiKeyManager.getAPIKey(type: .TMDB)
    }
}

extension TitlesGroupCellViewModel: TitleActionsViewModelProtocol {
    func isTitleInStorage(at indexPath: IndexPath) -> Bool {
        storageManager.isInStorage(titles[indexPath.item])
    }
    
    func learnMoreAboutTitle(at indexPath: IndexPath) {
        showTitlePage(for: indexPath)
    }
    
    func deleteBookmark(at indexPath: IndexPath) {
        storageManager.delete(titles[indexPath.item])
    }
    
    func addBookmarkForTitle(at indexPath: IndexPath) {
        storageManager.save(titles[indexPath.item])
    }
    
    
}
