//
//  BookmarkCellViewModel.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 22.05.2022.
//

import Foundation

//MARK: - BookmarkCellViewModelProtocol

protocol BookmarkCellViewModelProtocol {
    var titleID: Int? { get }
    var titleName: String { get }
    var overview: String { get }
    func fetchBackgroundImage(completion: @escaping (Data?) -> Void)
}

//MARK: - BookmarkCellViewModel

class BookmarkCellViewModel: BookmarkCellViewModelProtocol {
    
    //MARK: Properties
    
    var titleID: Int? {
        Int(title.titleID)
    }
    
    var titleName: String {
        title.name ?? title.originalName ?? title.originalTitle ?? ""
    }
    
    var overview: String {
        title.overview ?? ""
    }
    
    private let title: TitleStorageModel
    private let apiManager = APIKeyManager()
    private lazy var apiDataExtractor = TMDBDataExtractor(apiKey: apiManager.getAPIKey(type: .TMDB) ?? "")
    
    init(title: TitleStorageModel) {
        self.title = title
    }
    
    //MARK: - Methods
    
    func fetchBackgroundImage(completion: @escaping (Data?) -> Void) {
        guard let url = title.backdropPath else { return }
        apiDataExtractor.fetchImageData(from: url, completion: completion)
    }
    
    
}
