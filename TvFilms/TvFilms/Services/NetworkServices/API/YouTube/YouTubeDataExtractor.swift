//
//  YouTubeDataExtractor.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 20.05.2022.
//

import Foundation

class YouTubeDataExtractor {
    
    //MARK: Properties
    
    private let apiManager: YouTubeAPIManager
    
    //MARK: - Initialization
    
    init(apiKey: String) {
        apiManager = YouTubeAPIManager(apiKey: apiKey)
    }
    
    //MARK: - Methods
    
    func searchVideo(query: String, completion: @escaping (VideoComponents?) -> Void) {
        apiManager.searchVideo(query: query) { data, error in
            guard let strongData = data, error == nil else {
                completion(nil)
                print(error!.localizedDescription)
                return
            }
            
            let youTubeResults = self.decodeJSON(type: YouTubeVideo.self, from: strongData)
            completion(youTubeResults?.items?.first)
        }
    }
    
    //MARK: - Private methods
    
    private func decodeJSON<T: Decodable>(type: T.Type, from data: Data?) -> T? {
        guard let data = data else { return nil }

        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch let decodeError {
            print(decodeError)
            return nil
        }
    }
}
