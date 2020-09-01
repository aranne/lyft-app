//
//  Driver.swift
//  Lyft
//
//  Created by Weiran Fu on 9/1/20.
//  Copyright © 2020 aranne. All rights reserved.
//

import Foundation

class Driver {
    let name: String
    let thumbnail: String
    let licenseNumber: String
    let rating: Float
    let car: String
    
    init(name: String, thumbnail: String, licenseNumber: String, rating: Float, car: String) {
        self.name = name
        self.thumbnail = thumbnail
        self.licenseNumber = licenseNumber
        self.rating = rating
        self.car = car
    }
}
