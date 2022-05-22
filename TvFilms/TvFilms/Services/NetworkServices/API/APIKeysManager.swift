//
//  APIKeysManager.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 11.05.2022.
//

import Foundation

enum APIKeyTypes: String {
    case TMDB
    case YouTube
}

class APIKeyManager {
    func getAPIKey(type: APIKeyTypes) -> String? {
        guard let path = Bundle.main.path(forResource: "Info", ofType: ".plist") else { return nil }
        do {
            let value = try NSDictionary(contentsOf: URL(fileURLWithPath: path), error: ())
            guard
                let keys = value.object(forKey: "APIKeys") as? NSDictionary,
                let TMDBKey = keys.value(forKey: type.rawValue) as? String
            else { return nil }
            return TMDBKey
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}
