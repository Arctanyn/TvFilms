//
//  APICaller.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 16.03.2022.
//

import Foundation

enum APICallError: Error {
    case failedToGetData
}

fileprivate enum APIKeyType: String {
    case TMDB
    case YouTube
}

//MARK: - URL Constants

fileprivate struct URLConstants {
    static let baseURL = "https://api.themoviedb.org"
    static let youTubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
    static func getAPIKeys() -> NSDictionary? {
        guard let path = Bundle.main.path(forResource: "Info", ofType: ".plist")
        else { return nil }
        do {
            let value = try NSDictionary(contentsOf: URL(fileURLWithPath: path), error: ())
            guard let keys = value.object(forKey: "APIKeys") as? NSDictionary else { return nil }
            return keys
        } catch let error {
            print(error)
        }
        return nil
    }
}

//MARK: - Source URL

struct SourceURL {
    static let imagePath = "https://image.tmdb.org/t/p/w500" //+ poster path
    
    static let search = "\(URLConstants.baseURL)/3/search/multi?api_key=\(URLConstants.getAPIKeys()?.value(forKey: APIKeyType.TMDB.rawValue) ?? "")&query="
    
    static let popular = "\(URLConstants.baseURL)/3/tv/popular?api_key=\(URLConstants.getAPIKeys()?.value(forKey: APIKeyType.TMDB.rawValue) ?? "")&language=en-US"
    
    static let popularAnimeTVs = "\(URLConstants.baseURL)/3/discover/tv?api_key=\(URLConstants.getAPIKeys()?.value(forKey: APIKeyType.TMDB.rawValue) ?? "")&sort_by=popularity.desc&page=1&with_keywords=210024"
    
    static let popularAnimeMovies = "\(URLConstants.baseURL)/3/discover/movie?api_key=\(URLConstants.getAPIKeys()?.value(forKey: APIKeyType.TMDB.rawValue) ?? "")&sort_by=popularity.desc&page=1&with_keywords=210024"
    
    static let trendingMovies = "\(URLConstants.baseURL)/3/trending/movie/day?api_key=\(URLConstants.getAPIKeys()?.value(forKey: APIKeyType.TMDB.rawValue) ?? "")&language=en-US"
    
    static let trendingTVs = "\(URLConstants.baseURL)/3/trending/tv/day?api_key=\(URLConstants.getAPIKeys()?.value(forKey: APIKeyType.TMDB.rawValue) ?? "")&language=en-US"
    
    static let upcoming = "\(URLConstants.baseURL)/3/movie/upcoming?api_key=\(URLConstants.getAPIKeys()?.value(forKey: APIKeyType.TMDB.rawValue) ?? "")&language=en-US"
    
    static let topRated = "\(URLConstants.baseURL)/3/tv/top_rated?api_key=\(URLConstants.getAPIKeys()?.value(forKey: APIKeyType.TMDB.rawValue) ?? "")&language=en-US"
}

//MARK: - API Caller

class APICaller {

    static let shared = APICaller()
    
    func getTitles(from url: String, comlpletion: @escaping (Result<[TitleModel], Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            do {
                let json = try JSONDecoder().decode(TitlesResponse.self, from: data)
                comlpletion(.success(json.results))
            } catch let error {
                comlpletion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func searchTitles(query: String, completion: @escaping (Result<[TitleModel], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string: "\(SourceURL.search)\(query)&include_adult=false")
        else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(TitlesResponse.self, from: data)
                completion(.success(result.results))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getYouTubeVideo(query: String, completion: @escaping (Result<VideoComponents, Error>) -> Void) {
        guard
            let formatedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let APIKey = URLConstants.getAPIKeys()?[APIKeyType.YouTube.rawValue],
            let url = URL(string: "\(URLConstants.youTubeBaseURL)q=\(formatedQuery)&key=\(APIKey)")
        else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                let json = try JSONDecoder().decode(YouTubeSearch.self, from: data)
                guard let video = json.items?.first else {
                    completion(.failure(APICallError.failedToGetData))
                    return
                }
                completion(.success(video))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
}
