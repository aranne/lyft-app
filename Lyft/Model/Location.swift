//
//  Location.swift
//  Lyft
//
//  Created by Weiran Fu on 8/30/20.
//  Copyright © 2020 aranne. All rights reserved.
//

import Foundation

class Location: Codable {
    var title: String
    var subtitle: String
    let latitude: Double
    let longitude: Double
    
    init(title: String, subtitle: String, latitude: Double, longitude: Double) {
        self.title = title
        self.subtitle = subtitle
        self.latitude = latitude
        self.longitude = longitude
    }
}
