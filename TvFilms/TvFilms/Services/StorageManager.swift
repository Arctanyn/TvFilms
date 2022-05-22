//
//  StorageManager.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 20.03.2022.
//

import UIKit
import CoreData

class StorageManager {
    
    //MARK: Properties
    
    private let context: NSManagedObjectContext?
    
    //MARK: - Initialization

    init() {
        context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }
    
    //MARK: - Methods
    
    func save(_ title: TMDBTitle) {
        guard
            let context = self.context,
            let entityDescription = NSEntityDescription.entity(
                forEntityName: "TitleStorageModel",
                in: context
            ),
            let item = NSManagedObject(entity: entityDescription, insertInto: context) as? TitleStorageModel
        else { return }
        
        item.titleID = Int64(title.id)
        item.name = title.name
        item.backdropPath = title.backdropPath
        item.posterPath = title.posterPath
        item.originalTitle = title.originalTitle
        item.originalName = title.originalName
        item.overview = title.overview
        item.voteAverage = title.voteAverage ?? 0
        item.voteCount = Int64(title.voteCount ?? 0)
        item.popularity = title.popularity ?? 0
        item.firstAirDate = title.firstAirDate
        

        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchData(_ completion: @escaping ([TitleStorageModel]?) -> Void) {
        guard let context = context else { return }
        let request: NSFetchRequest<TitleStorageModel> = TitleStorageModel.fetchRequest()
        do {
            let fetchedTitles = try context.fetch(request)
            completion(fetchedTitles)
        } catch let error {
            completion(nil)
            print(error.localizedDescription)
        }
    }
    
    func delete(_ title: TitleStorageModel) {
        guard let context = context else { return }
        context.delete(title)
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func delete(_ title: TMDBTitle) {
        guard let context = context else { return }
        findObjectInStorage(title) { storageTitle in
            guard let storageTitle = storageTitle else { return }
            context.delete(storageTitle)
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteAll() {
        guard let context = context else { return }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TitleStorageModel")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func isInStorage(_ title: TMDBTitle) -> Bool {
        var titleModel: TitleStorageModel?
        findObjectInStorage(title) { storageTitle in
            titleModel = storageTitle
        }
        return titleModel != nil ? true : false
    }
    
    //MARK: - Private methods
    
    private func findObjectInStorage(_ title: TMDBTitle, completion: @escaping (TitleStorageModel?) -> Void) {
        guard let context = context else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TitleStorageModel")
        fetchRequest.predicate = NSPredicate(format: "titleID = %@", "\(title.id)")
        
        do {
            guard let results = try context.fetch(fetchRequest) as? [NSManagedObject] else { return }
            if !results.isEmpty {
                for result in results {
                    guard let storedTitle = result as? TitleStorageModel else { return }
                    completion(storedTitle)
                    return
                }
                completion(nil)
            } else {
                completion(nil)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
