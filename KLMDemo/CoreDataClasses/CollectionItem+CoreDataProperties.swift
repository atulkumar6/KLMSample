//
//  CollectionItem+CoreDataProperties.swift
//  
//
//  Created by Atul Kumar on 9/11/18.
//
//

import Foundation
import CoreData


extension CollectionItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CollectionItem> {
        return NSFetchRequest<CollectionItem>(entityName: "CollectionItem")
    }

    @NSManaged public var isFavorite: Bool
    @NSManaged public var tag: Int16

}
