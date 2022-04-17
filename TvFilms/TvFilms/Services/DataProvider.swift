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
    
    func fetchData(from url: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: url) else { return }
        if let cachedData = dataCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedData as Data)
        } else {
            DispatchQueue.global(qos: .userInteractive).async { [dataCache] in
                guard let data = try? Data(contentsOf: url) else {
                    completion(nil)
                    return
                }
                dataCache.setObject(data as NSData, forKey: url.absoluteString as NSString)
                completion(data)
            }
        }
    }
}
