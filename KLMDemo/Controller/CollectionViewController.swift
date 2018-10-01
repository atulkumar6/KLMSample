//
//  CollectionView.swift
//  KLMDemo
//
//  Created by Atul Kumar on 9/11/18.
//  Copyright © 2018 Atul Kumar. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CollectionViewController: UIViewController {
    // UI Outles
    @IBOutlet var collectionView:UICollectionView?
    // Class Attributes
    var parentController:UIViewController?
    var filteredItemNumber = Constants.invalidItemTag
    fileprivate var totalSections = Constants.totalSections
    fileprivate var locationCoordinates:[Dictionary<String,NSNumber>]?
    
    fileprivate let reuseIdentifier = "collection"
    let coreDataManager = CoreDataManager()
    
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationCoordinates = Helper.readPlist()
        saveDataInDataBase()
    }
    private func saveDataInDataBase() {
        var itemCount = 1
        guard let count = locationCoordinates?.count else {
            return
        }
        for i in 0..<count {
            let data = locationCoordinates?[i]
            let item = CollectionItem(context: coreDataManager.getContext())
            item.isFavorite = false
            item.tag = Int16(itemCount)
            if let lattitude = data?["latitude"]?.doubleValue, let longitude = data?["longitude"]?.doubleValue {
                item.lattitude = lattitude
                item.longitude = longitude
            }
            coreDataManager.insertRecordToDb(item)
            itemCount += 1
        }
        defer {
            coreDataManager.saveContext()
        }
    }
}
// protocol extension
extension CollectionItemProtocol {
    typealias searchItemTextType = Int
}
// protocol definitation
extension CollectionViewController:CollectionItemProtocol {
    var searchItemNumber: searchItemTextType {
        return filteredItemNumber
    }
    func removeItemNumber() {
        filteredItemNumber = Constants.invalidItemTag
    }
}
extension CollectionViewController:HomeScreenProtocol {
    // custom protocol implementation
    func reloadCollectionView() {
        collectionView?.reloadData()
    }
    func filterCollectionItem(itemNumber:Int) {
        filteredItemNumber = itemNumber
        if searchItemNumber > Constants.totalItem || searchItemNumber <= Constants.invalidItemTag {
            totalSections = Constants.zeroSection
        }
        else {
            totalSections = Constants.oneSection
        }
        reloadCollectionView()
    }
    func removeTextSearchBar() {
        totalSections = Constants.totalSections
        reloadCollectionView()
        self.removeItemNumber()
    }
}
extension CollectionViewController:UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return totalSections
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if totalSections == Constants.oneSection {
            return Constants.oneSection
        }
        if section == totalSections - 1 {
            return Constants.numberOfItemsInLastSection
        }
        return Constants.numberOfItemsInSection
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier, for: indexPath) as? CollectionCell
        var itemTag = Constants.invalidItemTag
        if totalSections == Constants.oneSection  {
            itemTag = searchItemNumber
        }
        else {
            itemTag = Constants.totalItem - ((indexPath.section * Constants.numberOfItemsInSection) + indexPath.item)
        }
        cell?.tagLabel?.text = String(itemTag)
        // fetching records from core data
        if let item = coreDataManager.fetchRecordFromDb(Int16(itemTag))?.first {
            // MARK: Optional Chaining
            cell?.favoriteImageView?.isHidden = !item.isFavorite
        }
        return cell ?? CollectionCell()
    }
}
extension CollectionViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let descriptionController = Helper.getControllerInstance(Constants.descriptionControllerId) as? DescriptionController
        var itemTag = Constants.invalidItemTag
        if totalSections == Constants.oneSection  {
            itemTag = searchItemNumber
        }
        else {
            itemTag = Constants.totalItem - (indexPath.section * Constants.numberOfItemsInSection + indexPath.item)
        }
        descriptionController?.itemTag = Int16(itemTag)
        if let controller = descriptionController {
            parentController?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
extension CollectionViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.itemSize, height: Constants.itemSize)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minimumInteritemSpacingForSection
    }
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minimumInteritemSpacingForSection
    }
}
