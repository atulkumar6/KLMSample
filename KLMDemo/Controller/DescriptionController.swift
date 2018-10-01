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

class DescriptionController: UIViewController {
    // UI Outles
    @IBOutlet var favoriteButton:UIButton?
    @IBOutlet var mapView:MKMapView?
    
    let coreDataManager = CoreDataManager()
    var itemTag = Int16(Constants.invalidItemTag)
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupFavoriteButton()
        setMapView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.hidesBackButton = false
        navigationController?.navigationBar.isHidden = false
        title = "\(itemTag.hashValue)"
    }
    // MARK: Private Methods
    private func setupFavoriteButton() {
        // If let optional binding
        if let item = coreDataManager.fetchRecordFromDb(itemTag)?.first {
            // Guard Statement
            guard !item.isFavorite else {
                favoriteButton?.backgroundColor = .red
                favoriteButton?.setTitle(Constants.unmarkAsFavouriteText, for: .normal)
                favoriteButton?.isSelected = true
                return
            }
        }
    }
    private func setMapView() {
        let regionRadius: CLLocationDistance = CLLocationDistance(Constants.regionRadius)
        //MARK: Nested function
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                      regionRadius, regionRadius)
            mapView?.setRegion(coordinateRegion, animated: true)
        }
        guard let item = coreDataManager.fetchRecordFromDb(itemTag)?.first else{
            return
        }
        let initialLocation = CLLocation(latitude:item.lattitude, longitude: item.longitude)
        
        let artwork = Artwork(title: "\(itemTag)",
            coordinate:initialLocation.coordinate)
        centerMapOnLocation(location:initialLocation)
        mapView?.addAnnotation(artwork)
    }
    // MARK: UIButton Actions
    @IBAction func favoriteButtonAction() {
        if favoriteButton?.isSelected ?? false {
            favoriteButton?.isSelected = false
            favoriteButton?.setTitle(Constants.markAsFavouriteText, for: .normal)
            favoriteButton?.backgroundColor = .white
            // If let optional binding
            if let item = coreDataManager.fetchRecordFromDb(itemTag)?.first {
                item.isFavorite = false
            }
        }
        else {
            favoriteButton?.isSelected = true
            favoriteButton?.setTitle(Constants.unmarkAsFavouriteText, for: .normal)
            favoriteButton?.backgroundColor = .red
            // MARK: If let optional binding
            if let item = coreDataManager.fetchRecordFromDb(itemTag)?.first {
                item.isFavorite = true
            }
        }
        // MARK : Swift Defer Statement
        defer {
            coreDataManager.saveContext()
        }
    }
}
