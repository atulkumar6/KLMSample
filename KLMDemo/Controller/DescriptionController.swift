//
//  DescriptionController.swift
//  KLMDemo
//
//  Created by Atul Kumar on 9/11/18.
//  Copyright © 2018 Atul Kumar. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class DescriptionController: UIViewController,MKMapViewDelegate {
    // UI Outles
    @IBOutlet var btnIsFav:UIButton?
    @IBOutlet var mapVw:MKMapView?
    // Class Attributes, declared as optional
    let coreDataManager = CoreDataManager()
    var itemTag:Int16?
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // If let optional binding
        if let item = coreDataManager.fetchRecordFromDb(itemTag ?? Int16(Constants.invalidItemTag))?.first {
                if item.isFavorite {
                btnIsFav?.backgroundColor = UIColor.red
                btnIsFav?.setTitle(Constants.unmarkAsFavouriteText, for: .normal)
                btnIsFav?.isSelected = true
                }
            }
        
        setMapView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.hidesBackButton = false
        navigationController?.navigationBar.isHidden = false
        title = "\(itemTag?.hashValue ?? Constants.invalidItemTag)"
    }
    fileprivate func setMapView() {
        let regionRadius: CLLocationDistance = CLLocationDistance(Constants.regionRadius)
        //MARK: Nested function
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                      regionRadius, regionRadius)
            mapVw?.setRegion(coordinateRegion, animated: true)
        }
        let initialLocation = CLLocation(latitude: Constants.lattitude, longitude: Constants.longitude)

        let artwork = Artwork(title: "\(itemTag ?? Int16(Constants.invalidItemTag))",
                              coordinate: CLLocationCoordinate2D(latitude: Constants.lattitude, longitude:Constants.longitude))
        centerMapOnLocation(location:initialLocation)
        mapVw?.addAnnotation(artwork)
    }
    // MARK: UIButton Actions
    @IBAction func btnIsFavClick() {
        if btnIsFav?.isSelected ?? false {
            btnIsFav?.isSelected = false
            btnIsFav?.setTitle(Constants.markAsFavouriteText, for: .normal)
            btnIsFav?.backgroundColor = UIColor.white
            // If let optional binding
            if let item = coreDataManager.fetchRecordFromDb(itemTag ?? Int16(Constants.invalidItemTag))?.first {
                item.isFavorite = false
            }
        }
        else {
            btnIsFav?.isSelected = true
            btnIsFav?.setTitle(Constants.unmarkAsFavouriteText, for: .normal)
            btnIsFav?.backgroundColor = UIColor.red
            // MARK: If let optional binding
            if let item = coreDataManager.fetchRecordFromDb(itemTag ?? Int16(Constants.invalidItemTag))?.first {
                item.isFavorite = true
            }
            else {
                // creating objects into context, injecting itemtag and Bool value dependency.
                coreDataManager.insertRecordToDb(itemTag ?? Int16(Constants.invalidItemTag),btnIsFav?.isSelected ?? false)
               }
        }
        
    }
   
}
