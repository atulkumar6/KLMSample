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
    fileprivate var context:NSManagedObjectContext?
    var itemTag:Int16?
    

    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let app  = UIApplication.shared.delegate as? AppDelegate
        context = app?.persistentContainer.viewContext
        // If let optional binding
            if let item = fetchRecordFromDb()?.first {
                if item.isFavorite {
                btnIsFav?.backgroundColor = UIColor.red
                btnIsFav?.isSelected = true
                }
            }
        
        setMapView()
        
    }
    
    fileprivate func setMapView() {
        let regionRadius: CLLocationDistance = 1000
        //MARK: Nested function
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                      regionRadius, regionRadius)
            mapVw?.setRegion(coordinateRegion, animated: true)
        }
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)

        let artwork = Artwork(title: "\(itemTag ?? -1)",
                              coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        centerMapOnLocation(location:initialLocation)
        mapVw?.addAnnotation(artwork)
      
    }
    
//    // MARK: MapView Delegate
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let annotationVw = MKAnnotationView()
//        annotationVw.image = UIImage(named: "annotation")
//         return annotationVw
//
//    }
    
    // MARK: UIButton Actions
    @IBAction func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnIsFavClick() {
        if btnIsFav?.isSelected ?? false {
            btnIsFav?.isSelected = false
            btnIsFav?.backgroundColor = UIColor.white
            // If let optional binding
            if let item = fetchRecordFromDb()?.first {
                item.isFavorite = false
            }
        }
        else {
            btnIsFav?.isSelected = true
            btnIsFav?.backgroundColor = UIColor.red
            // MARK: If let optional binding
            if let item = fetchRecordFromDb()?.first {
                item.isFavorite = true
            }
            else {
                // creating objects into context.
                let entity = NSEntityDescription.entity(forEntityName: "CollectionItem", in: context ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)) ?? NSEntityDescription()
                let newItem = NSManagedObject(entity: entity, insertInto: context) as? CollectionItem
                newItem?.tag = itemTag ?? -1
                newItem?.isFavorite = btnIsFav?.isSelected ?? false
                
            }
        }
        
        // MARK : Swift Defer Statement
        defer {
            // optional try for error handling
            try? context?.save()
        }
    }
    
    // MARK: Accessing data from Core data.
    fileprivate func fetchRecordFromDb() -> [CollectionItem]? {
        let fetchReq = NSFetchRequest<CollectionItem>(entityName: "CollectionItem")
        fetchReq.predicate = NSPredicate(format: "tag == %d", itemTag ?? -1)
        let fetchResult = try? context?.fetch(fetchReq) ?? nil
        return fetchResult ?? nil
    }
}
