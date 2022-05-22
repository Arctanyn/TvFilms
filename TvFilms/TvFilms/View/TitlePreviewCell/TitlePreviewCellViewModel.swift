//
//  TitlePreviewCellViewModel.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 20.05.2022.
//

import Foundation

//MARK: - TitlePreviewCellViewModelProtocol

protocol TitlePreviewCellViewModelProtocol {
    var titleID: Int? { get }
    var titleName: String { get }
    var overview: String { get }
    var voteAverage: Double? { get }
    func fetchPosterImage(completion: @escaping (Data?) -> Void)
}

//MARK: - TitlePreviewCellViewModel

class TitlePreviewCellViewModel: TitlePreviewCellViewModelProtocol {
    
    //MARK: Properties
    
    var titleID: Int? {
        title.id
    }
    
    var titleName: String {
        (title.name ?? title.originalName ?? title.originalTitle) ?? ""
    }
    
    var overview: String {
        title.overview ?? ""
    }
    
    var voteAverage: Double? {
        title.voteAverage
    }
    
    private let title: TMDBTitle
    private let apiDataExtractor: TMDBDataExtractor
    
    //MARK: - Initialization
    
    init(title: TMDBTitle, apiKey: String) {
        self.title = title
        apiDataExtractor = TMDBDataExtractor(apiKey: apiKey)
    }
    
    //MARK: - Methods
    
    func fetchPosterImage(completion: @escaping (Data?) -> Void) {
        guard let url = title.posterPath else { return }
        apiDataExtractor.fetchImageData(from: url, completion: completion)
    }
}
