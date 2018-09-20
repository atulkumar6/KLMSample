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

class CollectionViewController: UIViewController,HomeScreenProtocol {
    // UI Outles
    @IBOutlet var vwCollection:UICollectionView?
    // Class Attributes
    fileprivate let reuseIdentifier = "collection"
    var parentNav:UIViewController?
    let coreDataManager = CoreDataManager()
    var filteredItemNumber = Constants.invalidItemTag
    fileprivate var totalSections = Constants.totalSections
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // custom protocol method
    func reloadCollectionView() {
        vwCollection?.reloadData()
    }
    func filterCollectionItem(itemNumber:Int) {
        filteredItemNumber = itemNumber
        if filteredItemNumber > Constants.totalItem || filteredItemNumber <= Constants.invalidItemTag {
            totalSections = Constants.zeroSection
        }
        else {
            totalSections = Constants.oneSection
        }
        reloadCollectionView()
    }
    func clearTextSearchBar() {
        totalSections = Constants.totalSections
        reloadCollectionView()
    }

}

extension CollectionViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate {
    // MARK: CollectionView DataSource
    //1
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return totalSections
    }
    //2
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
    //3
     func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier, for: indexPath) as? CollectionCell
        var itemTag = Constants.invalidItemTag
        if totalSections == Constants.oneSection  {
            itemTag = filteredItemNumber
        }
        else {
         itemTag = Constants.totalItem - ((indexPath.section * Constants.numberOfItemsInSection) + indexPath.item)
        }
        cell?.lblTag?.text = String(itemTag)
        // fetching records from core data
        if let item = coreDataManager.fetchRecordFromDb(Int16(itemTag))?.first {
            // MARK: Optional Chaining
            cell?.imgvwFav?.isHidden = !item.isFavorite
        }
        else {
            cell?.imgvwFav?.isHidden = true
        }
        return cell ?? CollectionCell()
    }
    //4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: Constants.itemSize, height: Constants.itemSize)
      }
    //5
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    //6
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    // MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let descController = Helper.getControllerInstance(Constants.descriptionControllerId) as? DescriptionController
        let itemTag = Constants.totalItem - (indexPath.section * Constants.numberOfItemsInSection + indexPath.item)
        descController?.itemTag = Int16(itemTag)
        parentNav?.navigationController?.pushViewController(descController ?? UIViewController(), animated: true)
    }
   
}

