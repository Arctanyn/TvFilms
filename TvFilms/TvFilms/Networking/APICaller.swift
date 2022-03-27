//
//  APICaller.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 16.03.2022.
//

import Foundation

fileprivate enum APICallError: Error {
    case dataExtrationError
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

//MARK: Source URL

struct SourceURL {
    
    private lazy var TMDB_APIKey = URLConstants.getAPIKeys()?.value(forKey: APIKeyType.TMDB.rawValue) as? String
    
    static let imagePath = "https://image.tmdb.org/t/p/w500" //+ poster path
    
    private(set) lazy var search = "\(URLConstants.baseURL)/3/search/multi?api_key=\(TMDB_APIKey ?? "")&query="
    
    private(set) lazy var popular = "\(URLConstants.baseURL)/3/tv/popular?api_key=\(TMDB_APIKey ?? "")&language=en-US"
    
    private(set) lazy var popularAnimeTVs = "\(URLConstants.baseURL)/3/discover/tv?api_key=\(TMDB_APIKey ?? "")&sort_by=popularity.desc&page=1&with_keywords=210024"
    
    private(set) lazy var popularAnimeMovies = "\(URLConstants.baseURL)/3/discover/movie?api_key=\(TMDB_APIKey ?? "")&sort_by=popularity.desc&page=1&with_keywords=210024"
    
    private(set) lazy var trendingMovies = "\(URLConstants.baseURL)/3/trending/movie/day?api_key=\(TMDB_APIKey ?? "")&language=en-US"
    
    private(set) lazy var trendingTVs = "\(URLConstants.baseURL)/3/trending/tv/day?api_key=\(TMDB_APIKey ?? "")&language=en-US"
    
    private(set) lazy var upcoming = "\(URLConstants.baseURL)/3/movie/upcoming?api_key=\(TMDB_APIKey ?? "")&language=en-US"
    
    private(set) lazy var topRated = "\(URLConstants.baseURL)/3/tv/top_rated?api_key=\(TMDB_APIKey ?? "")&language=en-US"
}

//MARK: - API Caller

class APICaller {

    static let shared = APICaller()
    
    func getTitles(from url: String, completion: @escaping (Result<[TitleModel], Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(TitlesResponse.self, from: data)
                guard let titles = result.results else { return }
                completion(.success(titles))
            } catch let error {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func searchTitles(query: String, completion: @escaping (Result<[TitleModel], Error>) -> Void) {
        var sourceURL = SourceURL()
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string: "\(sourceURL.search)\(query)&include_adult=false")
        else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(TitlesResponse.self, from: data)
                guard let titles = result.results else { return }
                completion(.success(titles))
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
                let result = try JSONDecoder().decode(YouTubeSearch.self, from: data)
                guard let video = result.items?.first else {
                    completion(.failure(APICallError.dataExtrationError))
                    return
                }
                completion(.success(video))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
}
