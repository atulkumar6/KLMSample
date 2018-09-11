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

class CollectionView: UIViewController,HomeScreenProtocol {
    // UI Outles
    @IBOutlet var vwCollection:UICollectionView?

    // Class Attributes
    fileprivate let reuseIdentifier = "collection"
    var parentNav:UIViewController?
    fileprivate var context:NSManagedObjectContext?

    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let app  = UIApplication.shared.delegate as? AppDelegate
        context = app?.persistentContainer.viewContext
       // vwCollection?.register(CollectionCell.self, forCellWithReuseIdentifier:reuseIdentifier)
        
    }
    // custom protocol method
    func reloadCollectionView() {
        vwCollection?.reloadData()
    }
}


extension CollectionView:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate {
    
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
        let fetchReq = NSFetchRequest<CollectionItem>(entityName: "CollectionItem")
        fetchReq.predicate = NSPredicate(format: "tag == %d", itemTag)
        let fetchResult = (try? context?.fetch(fetchReq)) ?? nil
        
        if let item = fetchResult?.first {
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
        let cntrl = Helper.getControllerInstance("DescriptionController") as? DescriptionController
        let itemTag = Constants.totalItem - (indexPath.section * Constants.numberOfItemsInSection + indexPath.item)
        
        cntrl?.itemTag = Int16(itemTag)
        self.parentNav?.navigationController?.pushViewController(cntrl ?? UIViewController(), animated: true)
    }

}
