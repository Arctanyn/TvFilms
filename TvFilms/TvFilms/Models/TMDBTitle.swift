//
//  Titles.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 07.05.2022.
//

import Foundation

// MARK: - TitlesResult

struct TitlesResult: Decodable {
    let page: Int?
    let results: [TMDBTitle]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result

struct TMDBTitle: Decodable {
    let id: Int
    let backdropPath, firstAirDate: String?
//    let genreIDS: [Int]?
    let name: String?
    let originalName, originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
//        case genreIDS = "genre_ids"
        case id
        case name
        case originalName = "original_name"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    init(titleStorageModel: TitleStorageModel) {
        self.id = Int(titleStorageModel.titleID)
        self.backdropPath = titleStorageModel.backdropPath
        self.firstAirDate = titleStorageModel.firstAirDate
        self.name = titleStorageModel.name
        self.originalName = titleStorageModel.originalName
        self.originalTitle = titleStorageModel.originalTitle
        self.overview = titleStorageModel.overview
        self.popularity = titleStorageModel.popularity
        self.posterPath = titleStorageModel.posterPath
        self.voteAverage = titleStorageModel.voteAverage
        self.voteCount = Int(titleStorageModel.voteCount)
    }
}


