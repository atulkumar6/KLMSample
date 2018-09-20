//
//  CoreDataManager.swift
//  KLMDemo
//
//  Created by Atul Kumar on 9/20/18.
//  Copyright © 2018 Atul Kumar. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    fileprivate lazy var context:NSManagedObjectContext? = {
        return persistentContainer.viewContext
    }()
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "KLMDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    func getContext() -> NSManagedObjectContext? {
        return context
    }
    // MARK: Accessing data from Core data.
    func fetchRecordFromDb(_ itemTag:Int16) -> [CollectionItem]? {
        let fetchReq = NSFetchRequest<CollectionItem>(entityName: Constants.collectionItem)
        fetchReq.predicate = NSPredicate(format: "tag == %d",itemTag)
        let fetchResult = try? context?.fetch(fetchReq) ?? nil
        return fetchResult ?? nil
    }
    func insertRecordToDb(_ itemTag:Int16, _ isSelected:Bool) {
        let entity = NSEntityDescription.entity(forEntityName: Constants.collectionItem, in: context ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)) ?? NSEntityDescription()
        let newItem = NSManagedObject(entity: entity, insertInto: context) as? CollectionItem
        newItem?.tag = itemTag
        newItem?.isFavorite = isSelected
        // MARK : Swift Defer Statement
        defer {
            // optional try for error handling
            saveContext()
        }
    }
    // MARK: - Core Data Saving support
    func saveContext () {
        if context?.hasChanges == true {
            do {
                try context?.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
        }
    }
   
}
