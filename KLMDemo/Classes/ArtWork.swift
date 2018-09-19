//
//  ArtWork.swift
//  KLMDemo
//
//  Created by Atul Kumar on 9/11/18.
//  Copyright © 2018 Atul Kumar. All rights reserved.
//

import Foundation
import MapKit

// Model class for Map annotation view.
class Artwork: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let title: String?
    // MARK: Designated Initializer
    init(_ title: String, _ coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
    // MARK: Convenience Initializer
    convenience init(title: String, coordinate: CLLocationCoordinate2D) {
        self.init(title,coordinate)
    }
}
