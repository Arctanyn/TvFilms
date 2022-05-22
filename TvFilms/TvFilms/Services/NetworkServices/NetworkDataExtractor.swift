//
//  DataProvider.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 16.03.2022.
//

import UIKit

class NetworkDataManager {

    static let shared = NetworkDataManager()
    private var dataCache = NSCache<NSString, NSData>()

    //MARK: - Methods
    
    func fetchData(from url: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: url) else { return}
        if let cachedData = dataCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedData as Data)
        } else {
            DispatchQueue.global(qos: .userInteractive).async {
                guard let data = try? Data(contentsOf: url) else {
                    completion(nil)
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    self?.dataCache.setObject(data as NSData, forKey: url.absoluteString as NSString)
                    completion(data)
                }
            }
        }
    }
}
