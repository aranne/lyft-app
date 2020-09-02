//
//  DriverService.swift
//  Lyft
//
//  Created by Weiran Fu on 9/1/20.
//  Copyright © 2020 aranne. All rights reserved.
//

import Foundation
import CoreLocation

class DriverService {
    static let shared = DriverService()
    
    private init() {}
    
    func getDriver(pickupLocation: Location) -> (Driver, Int) {
        let random = Double(1 + arc4random_uniform(5)) / 500.0
        let signRandom = arc4random_uniform(10)
        var randomLatitude: Double!
        var randomLongitude: Double!
        if  signRandom < 3 {
            randomLatitude = pickupLocation.latitude + random
            randomLongitude = pickupLocation.longitude + random
        } else if signRandom < 6 {
            randomLatitude = pickupLocation.latitude - random
            randomLongitude = pickupLocation.longitude - random
        } else if signRandom < 8 {
            randomLatitude = pickupLocation.latitude + random
            randomLongitude = pickupLocation.longitude - random
        } else {
            randomLatitude = pickupLocation.latitude - random
            randomLongitude = pickupLocation.longitude + random
        }
        let coordinate = CLLocationCoordinate2D(latitude: randomLatitude, longitude: randomLongitude)
        let driver = Driver(name: "Alicia Castillo", thumbnail: "alicia", licenseNumber: "7WB312S", rating: 5.0, car: "Hyundai Sonata", coordinate: coordinate)
        return (driver, 10)
    }
}
