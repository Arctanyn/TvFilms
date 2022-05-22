//
//  NetworkService.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 06.05.2022.
//

import Foundation

class NetworkService {
    func createURL(scheme: String, host: String, path: String, queryParameters: [String: String]?) -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        if let queryParameters = queryParameters {
            components.queryItems = queryParameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }
        return components.url
    }
    
    func createTask(with url: URL, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        return task
    }
}
