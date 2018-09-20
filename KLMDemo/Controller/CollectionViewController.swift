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
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let flowLayout = vwCollection?.collectionViewLayout as? UICollectionViewFlowLayout,
            let collectionView = vwCollection {
            let w = collectionView.frame.size.width - 20
            flowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize
            flowLayout.estimatedItemSize = CGSize(width: 200, height: 200)
        }
    }
    // custom protocol method
    func reloadCollectionView() {
        vwCollection?.reloadData()
    }
}

extension CollectionViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate {
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        vwCollection?.collectionViewLayout.invalidateLayout()
//    }
    // MARK: CollectionView DataSource
    //1
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constants.totalSections
    }
    //2
     func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        if section == Constants.totalSections - 1 {
           return Constants.numberOfItemsInLastSection
        }
        return Constants.numberOfItemsInSection
    }
    //3
     func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier, for: indexPath) as? CollectionCell
        let itemTag = Constants.totalItem - ((indexPath.section * Constants.numberOfItemsInSection) + indexPath.item)
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
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return UICollectionViewFlowLayoutAutomaticSize
//    }
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
        let cntrl = Helper.getControllerInstance(Constants.descriptionControllerId) as? DescriptionController
        let itemTag = Constants.totalItem - (indexPath.section * Constants.numberOfItemsInSection + indexPath.item)
        cntrl?.itemTag = Int16(itemTag)
        parentNav?.navigationController?.pushViewController(cntrl ?? UIViewController(), animated: true)
    }
}
