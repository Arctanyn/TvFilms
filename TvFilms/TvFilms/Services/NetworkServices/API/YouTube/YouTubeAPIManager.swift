//
//  APIManagerYouTube.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 20.05.2022.
//

import Foundation

fileprivate enum YouTubeAPIBase: String {
    case scheme = "https"
    case host = "youtube.googleapis.com"
}

fileprivate enum YouTubeAPIType {
    case video
    
    var path: String {
        switch self {
        case .video:
            return "/youtube/v3/search"
        }
    }
}

//MARK: - APIManagerYouTube

class YouTubeAPIManager {
    
    //MARK: Properties
    
    private let apiKey: String
    private let networkService = NetworkService()
    
    //MARK: - Initialization
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    //MARK: - Methods
    
    func searchVideo(query: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = networkService.createURL(
            scheme: YouTubeAPIBase.scheme.rawValue,
            host: YouTubeAPIBase.host.rawValue,
            path: YouTubeAPIType.video.path,
            queryParameters: prepareQueryParameters(
                query: query,
                key: apiKey
            )
        ) else { return }
        
        let task = networkService.createTask(with: url, completion: completion)
        task.resume()
    }
    
    //MARK: - Private methods
    
    private func prepareQueryParameters(query: String, key: String) -> [String: String] {
        var parameters: [String: String] = [:]
        parameters["q"] = query
        parameters["key"] = key
        return parameters
    }
}
