//
//  YouTubeSearch.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 20.03.2022.
//

import Foundation

struct YouTubeSearch: Decodable {
    let etag: String?
    let items: [VideoComponents]?
}

struct VideoComponents: Decodable {
    let etag: String?
    let id: VideoIDComponents?
    let kind: String?
}

struct VideoIDComponents: Decodable {
    let kind: String?
    let videoId: String?
}
