//
//  DriverService.swift
//  Lyft
//
//  Created by Weiran Fu on 9/1/20.
//  Copyright © 2020 aranne. All rights reserved.
//

import Foundation

class DriverService {
    static let shared = DriverService()
    
    private init() {}
    
    func getDriver(pickupLocation: Location) -> (Driver, Int) {
        let driver = Driver(name: "Alicia Castillo", thumbnail: "alicia", licenseNumber: "7WB312S", rating: 5.0, car: "Hyundai Sonata")
        return (driver, 10)
    }
}
