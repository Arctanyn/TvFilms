//
//  TitleSearchResultViewModel.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 21.05.2022.
//

import Foundation

//MARK: - TitleSearchResultViewModelProtocol

protocol TitleSearchResultViewModelProtocol: TitleActionsViewModelProtocol {
    var resultCount: Int { get }
    func idForTitle(at indexPath: IndexPath) -> Int
    func viewModelForCell(at indexPath: IndexPath) -> TitlePreviewCellViewModelProtocol
    func showTitlePageForCell(at indexPath: IndexPath)
    func clearResult()
}

//MARK: - TitleSearchResultViewModel

class TitleSearchResultViewModel: TitleSearchResultViewModelProtocol {
    
    //MARK: Properties
    
    var resultCount: Int {
        titles.count
    }
    
    weak var delegate: SearchViewModelDelegate?
    
    private var titles: [TMDBTitle]
    private let apiKey: String
    private let storageManager = StorageManager()
    
    //MARK: - Initialization
    
    init(titles: [TMDBTitle], apiKey: String) {
        self.titles = titles
        self.apiKey = apiKey
    }
    
    //MARK: - Methods
    
    func idForTitle(at indexPath: IndexPath) -> Int {
        titles[indexPath.row].id
    }
    
    func viewModelForCell(at indexPath: IndexPath) -> TitlePreviewCellViewModelProtocol {
        TitlePreviewCellViewModel(title: titles[indexPath.row], apiKey: self.apiKey)
    }
    
    func showTitlePageForCell(at indexPath: IndexPath) {
        delegate?.showTitlePage(with: titles[indexPath.row])
    }
    
    func clearResult() {
        titles = []
    }
}

//MARK: - TitleActionsViewModelProtocol

extension TitleSearchResultViewModel: TitleActionsViewModelProtocol {
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
        showTitlePageForCell(at: indexPath)
    }
}
