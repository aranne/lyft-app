//
//  RideQuoteService.swift
//  Lyft
//
//  Created by Weiran Fu on 8/30/20.
//  Copyright © 2020 aranne. All rights reserved.
//

import Foundation
import CoreLocation

class RideQuoteService {
    static let shared = RideQuoteService()
    
    private init() {}
    
    func getQuotes(pickupLocation: Location, dropoffLocation: Location) -> [RideQuote] {
        let location1 = CLLocation(latitude: pickupLocation.latitude, longitude: pickupLocation.longitude)
        let location2 = CLLocation(latitude: dropoffLocation.latitude, longitude: dropoffLocation.longitude)
        
        let distance = location1.distance(from: location2)
        let minimumAmount = 3.0
        
        return [
            RideQuote(thumbnail: "ride-shared", name: "Shared", capacity: "1-2", price: minimumAmount + (distance * 0.005), time: Date()),
            RideQuote(thumbnail: "ride-compact", name: "Compact", capacity: "4", price: minimumAmount + (distance * 0.009), time: Date()),
            RideQuote(thumbnail: "ride-large", name: "Large", capacity: "6", price: minimumAmount + (distance * 0.015), time: Date())
        ]
    }
}
