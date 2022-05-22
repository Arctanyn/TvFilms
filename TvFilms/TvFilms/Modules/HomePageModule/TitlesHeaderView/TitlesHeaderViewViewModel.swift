//
//  TitlesHeaderViewViewModel.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 11.05.2022.
//

import Foundation

//MARK: - TitlesHeaderViewViewModelProtocol

protocol TitlesHeaderViewViewModelProtocol {
    var titleName: String? { get }
    var overview: String? { get }
    func fetchTitle(completion: @escaping () -> Void)
    func fetchImageData(completion: @escaping (Data?) -> Void)
    func showTitlePage()
}

//MARK: - TitlesHeaderViewViewModel

class TitlesHeaderViewViewModel: TitlesHeaderViewViewModelProtocol {
    var titleName: String? {
        title?.name ?? title?.originalName ?? title?.originalTitle
    }
    
    var overview: String? {
        title?.overview
    }
    
    weak var delegate: ViewModelRouteDelegate?
    
    private var title: TMDBTitle?
    private let apiKeyManager = APIKeyManager()
    private lazy var apiKey = apiKeyManager.getAPIKey(type: .TMDB)
    private lazy var apiDataExtractor = TMDBDataExtractor(apiKey: apiKey ?? "")
    
    //MARK: - Methods
    
    func fetchTitle(completion: @escaping () -> Void) {
        guard let category = TitlesCategory.allCases.randomElement() else { return }
        apiDataExtractor.fetchTitles(category: category) { [weak self] fetchedTitles in
            guard let titles = fetchedTitles else { return }
            self?.title = titles.randomElement()
            completion()
        }
    }
    
    func fetchImageData(completion: @escaping(Data?) -> Void) {
        guard let url = title?.posterPath else { return }
        apiDataExtractor.fetchImageData(from: url) { imageData in
            completion(imageData)
        }
    }
    
    func showTitlePage() {
        guard let title = title else { return }
        delegate?.showTitlePage(with: title)
    }
}
