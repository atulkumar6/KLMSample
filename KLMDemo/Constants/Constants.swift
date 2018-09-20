//
//  Constants.swift
//  KLMDemo
//
//  Created by Atul Kumar on 9/11/18.
//  Copyright © 2018 Atul Kumar. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    // Constants for CollectionView Items
    static let totalItem = 98
    static let numberOfItemsInSection = 3
    static let totalSections = 33
    static let numberOfItemsInLastSection = 2
    static let itemSize = UIScreen.main.bounds.size.width/3 - 10
    // Font Name
    static let helvitica = "HelveticaNeue-Bold"
    // MARK: StoryboardID
    static let homeScreenControllerId = "HomeScreen"
    static let collectionViewControllerId = "CollectionView"
    static let descriptionControllerId = "DescriptionController"
    // Predefined Text
    static let collectionViewNavBarTitle = "Collection"
    // Core data entity name
    static let collectionItem = "CollectionItem"
    // Location Attributes Constants
    static let regionRadius = 1000
    static let lattitude = 21.282778
    static let longitude = -157.829444
    // HomeScreenController PagemenuOption Attributes
    static let menuItemSeparatorWidth:CGFloat = 4.3
    static let menuMargin:CGFloat = 20
    static let menuHeight:CGFloat = 40
    static let menuItemFontSize:CGFloat = 13.0
    static let selectionIndicatorHeight:CGFloat = 2.0
    static let menuItemSeparatorPercentageHeight:CGFloat = 0.1
    
}
