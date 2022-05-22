//
//  TitlesListCellViewModel.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 09.05.2022.
//

import Foundation

//MARK: - TitlesListCellViewModelProtocol

protocol TitlesListCellViewModelProtocol {
    var titleID: Int { get }
    func fetchPoster(completion: @escaping (Data?) -> Void)
}

//MARK: - TitlesListCellViewModel

class TitlesListCellViewModel: TitlesListCellViewModelProtocol {
    
    //MARK: Properties
    var titleID: Int {
        title.id
    }
    
    private let title: TMDBTitle
    private let apiDataExtractor: TMDBDataExtractor
    
    //MARK: - Initialization
    
    init(title: TMDBTitle, apiKey: String) {
        self.title = title
        self.apiDataExtractor = TMDBDataExtractor(apiKey: apiKey)
    }
    
    //MARK: - Methods
    
    func fetchPoster(completion: @escaping (Data?) -> Void) {
        apiDataExtractor.fetchImageData(from: title.posterPath ?? "", completion: completion)
    }
}
