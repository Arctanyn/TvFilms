//
//  TMDBAPIManager.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 06.05.2022.
//

import Foundation

enum TitlesCategory: Int, CaseIterable {
    case popularTVs
    case popularMovies
    case popularAnime
    case popularAnimeMovies
    case trendingTVs
    case trendingMovies
    case topRatedTVs
    case topRatedMovies
    case upcomingMovies
    
    var name: String {
        switch self {
        case .popularTVs: return "Popular TV"
        case .popularMovies: return "Popular movies"
        case .popularAnime: return "Popular anime"
        case .popularAnimeMovies: return "Popular anime movies"
        case .trendingTVs: return "Trending TV"
        case .trendingMovies: return "Trending movies"
        case .topRatedTVs: return "Top rated TV"
        case .topRatedMovies: return "Top rated movies"
        case .upcomingMovies: return "Upcoming movies"
        }
    }
}

fileprivate enum APIBase: String {
    case scheme = "https"
    case host = "api.themoviedb.org"
    case imageHost = "image.tmdb.org"
}

fileprivate enum APIMediaType: String {
    case tv
    case movie
}

fileprivate enum APIType {
    case search
    case getImage
    case popular(mediaType: APIMediaType)
    case trending(mediaType: APIMediaType)
    case discover(mediaType: APIMediaType)
    case topRated(mediaType: APIMediaType)
    case upcoming(mediaType: APIMediaType)
    
    var path: String {
        switch self {
        case .search:
            return "/3/search/multi"
        case .getImage:
            return "/t/p/w500"
        case .popular(let mediaType):
            return "/3/\(mediaType)/popular"
        case .trending(let mediaType):
            return "/3/trending/\(mediaType)/day"
        case .discover(let mediaType):
            return "/3/discover/\(mediaType)"
        case .topRated(let mediaType):
            return "/3/\(mediaType)/top_rated"
        case .upcoming(let mediaType):
            return "/3/\(mediaType)/upcoming"
        }
    }
}


class TMDBAPIManager {
    
    //MARK: Properties
    
    private let apiKey: String
    private let networkService = NetworkService()
    
    //MARK: - Initialization
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    //MARK: - Methods
    
    func getTitles(category: TitlesCategory, completion: @escaping (Data?, Error?) -> Void) {
        
        guard let url = networkService.createURL(
            scheme: APIBase.scheme.rawValue,
            host: APIBase.host.rawValue,
            path: setAPIType(with: category).path,
            queryParameters: prepareTitlesQueryParameters(apiKey: apiKey, titleCategory: category)
        ) else { return }
        
        let task = networkService.createTask(with: url, completion: completion)
        task.resume()
    }
    
    func searchTitles(query: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = networkService.createURL(
            scheme: APIBase.scheme.rawValue,
            host: APIBase.host.rawValue,
            path: APIType.search.path,
            queryParameters: prepareSearchQueryParameters(accessKey: apiKey, query: query)
        ) else { return }

        let task = networkService.createTask(with: url, completion: completion)
        task.resume()
    }
    
    func fetchImage(from url: String, completion: @escaping (URL) -> Void) {
        guard let imageAccessURL = networkService.createURL(
            scheme: APIBase.scheme.rawValue,
            host: APIBase.imageHost.rawValue,
            path: APIType.getImage.path,
            queryParameters: nil
        ) else { return }
        completion(imageAccessURL)
    }
    
    //MARK: - Private methods
    
    private func prepareTitlesQueryParameters(apiKey: String, titleCategory: TitlesCategory) -> [String: String] {
        var parameters: [String: String] = [:]
        
        parameters["api_key"] = apiKey
        
        switch titleCategory {
        case .popularAnime, .popularAnimeMovies:
            parameters["sort_by"] = "popularity.desc"
            parameters["page"] = "1"
            parameters["with_keywords"] = "210024"
        default:
            parameters["language"] = "en-US"
        }
        
        return parameters
    }
    
    private func prepareSearchQueryParameters(accessKey: String, query: String) -> [String: String] {
        var parameters: [String: String] = [:]
        parameters["api_key"] = accessKey
        parameters["query"] = query
        return parameters
    }
    
    private func createDataTask(with url: URL, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        let session = URLSession.shared
        return session.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
    
    private func setAPIType(with titleCategory: TitlesCategory) -> APIType {
        switch titleCategory {
        case .popularTVs:
            return APIType.popular(mediaType: .tv)
        case .popularMovies:
            return APIType.popular(mediaType: .movie)
        case .popularAnime:
            return APIType.discover(mediaType: .tv)
        case .popularAnimeMovies:
            return APIType.discover(mediaType: .movie)
        case .trendingTVs:
            return APIType.trending(mediaType: .tv)
        case .trendingMovies:
            return APIType.trending(mediaType: .movie)
        case .topRatedTVs:
            return APIType.topRated(mediaType: .tv)
        case .topRatedMovies:
            return APIType.topRated(mediaType: .movie)
        case .upcomingMovies:
            return APIType.upcoming(mediaType: .movie)
        }
    }
}
