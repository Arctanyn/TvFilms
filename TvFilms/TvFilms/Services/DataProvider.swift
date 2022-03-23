//
//  DataProvider.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 16.03.2022.
//

import UIKit

class DataProvider {

    static let shared = DataProvider()
    private var dataCache = NSCache<NSString, NSData>()

    
    //MARK: - Methods
    
    func fetchData(from imageURL: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: imageURL) else { return }
        if let cachedData = dataCache.object(forKey: imageURL as NSString) {
            completion(cachedData as Data)
        } else {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url) { [weak self] data, _, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let data = data else {
                    completion(nil)
                    return
                }
                self?.dataCache.setObject(data as NSData, forKey: url.absoluteString as NSString)
                completion(data)
            }
            dataTask.resume()
        }
    }
}
