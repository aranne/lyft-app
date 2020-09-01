//
//  LocationAnnotation.swift
//  Lyft
//
//  Created by Weiran Fu on 9/1/20.
//  Copyright © 2020 aranne. All rights reserved.
//

import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let locationType: String
    
    init(coordinate: CLLocationCoordinate2D, locationType: String) {
        self.coordinate = coordinate
        self.locationType = locationType
    }
}
