//
//  CoreDataManager.swift
//  NSFetchedResultConAigerim
//
//  Created by Айгерим on 20.10.2024.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
      
        let container = NSPersistentContainer(name: "NSFetchedResultConAigerim")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
        
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    func saveJoke(jokeCodable: JokeCodable) {
        persistentContainer.performBackgroundTask { backgroundContext in
            let joke = Joke(context: backgroundContext)
            joke.id = jokeCodable.id
            joke.value = jokeCodable.value
            joke.downloadDate = Date()
            try? backgroundContext.save()
        }
        func delateJoke(joke: Joke) {
            persistentContainer.performBackgroundTask { backgroundContext in
                let jokeForDelate = backgroundContext.object(with: joke.objectID)
                backgroundContext.delete(jokeForDelate)
                try? backgroundContext.save()
            }
        }
    }
    
    
    
    
    
}
