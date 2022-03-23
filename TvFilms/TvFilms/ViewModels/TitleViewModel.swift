//
//  TitleViewModel.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 16.03.2022.


struct TitleViewModel {
    let name: String
    let overview: String
    let posterURL: String
    let backgroundPosterPath: String
    let voteAverage: Double
    let mediaType: String

    init(name: String, overview: String, posterURL: String, backgroundPosterPath: String, voteAverage: Double, mediaType: String) {
        self.name = name
        self.overview = overview
        self.posterURL = posterURL
        self.backgroundPosterPath = backgroundPosterPath
        self.voteAverage = voteAverage
        self.mediaType = mediaType
    }

    init(of title: TitleModel) {
        self.name = (title.original_name ?? title.original_title) ?? ""
        self.overview = title.overview ?? ""
        self.posterURL = title.poster_path ?? ""
        self.backgroundPosterPath = title.backdrop_path ?? ""
        self.voteAverage = title.vote_average ?? 0
        self.mediaType = title.media_type ?? ""
    }
}
