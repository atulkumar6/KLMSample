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
    @IBOutlet var btnBack:UIButton?
    // Class Attributes, declared as optional
    let coreDataManager = CoreDataManager()
    var itemTag:Int16?
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        // If let optional binding
            if let item = coreDataManager.fetchRecordFromDb(itemTag ?? -1)?.first {
                if item.isFavorite {
                btnIsFav?.backgroundColor = UIColor.red
                btnIsFav?.isSelected = true
                }
            }
        
        setMapView()
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

        let artwork = Artwork(title: "\(itemTag ?? -1)",
                              coordinate: CLLocationCoordinate2D(latitude: Constants.lattitude, longitude:Constants.longitude))
        centerMapOnLocation(location:initialLocation)
        mapVw?.addAnnotation(artwork)
    }
    // MARK: UIButton Actions
    @IBAction func btnBackClick() {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnIsFavClick() {
        if btnIsFav?.isSelected ?? false {
            btnIsFav?.isSelected = false
            btnIsFav?.backgroundColor = UIColor.white
            // If let optional binding
            if let item = coreDataManager.fetchRecordFromDb(itemTag ?? -1)?.first {
                item.isFavorite = false
            }
        }
        else {
            btnIsFav?.isSelected = true
            btnIsFav?.backgroundColor = UIColor.red
            // MARK: If let optional binding
            if let item = coreDataManager.fetchRecordFromDb(itemTag ?? -1)?.first {
                item.isFavorite = true
            }
            else {
                // creating objects into context, injecting itemtag and Bool value dependency.
                coreDataManager.insertRecordToDb(itemTag ?? -1,btnIsFav?.isSelected ?? false)
               }
        }
        
    }
   
}
