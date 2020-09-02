//
//  DriverViewController.swift
//  Lyft
//
//  Created by Weiran Fu on 9/2/20.
//  Copyright © 2020 aranne. All rights reserved.
//

import UIKit
import MapKit

class DriverViewController: UIViewController {
    
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var driverImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backButton: UIButton!
    
    var pickupLocation: Location!
    var dropoffLocation: Location!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add all corners
        driverImageView.layer.cornerRadius = driverImageView.frame.size.width / 2.0
        licenseLabel.layer.cornerRadius = 15.0
        licenseLabel.layer.borderColor = UIColor.gray.cgColor
        licenseLabel.layer.borderWidth = 1.0
        backButton.layer.cornerRadius = backButton.frame.size.width / 2.0
        
        let locations = LocationService.shared.getRecentLocations()
        pickupLocation = locations[0]
        dropoffLocation = locations[1]
        
        let (driver, eta) = DriverService.shared.getDriver(pickupLocation: pickupLocation)
        
        etaLabel.text = "ARRIVES IN \(eta) MIN"
        driverNameLabel.text = driver.name
        driverImageView.image = UIImage(named: driver.thumbnail)
        licenseLabel.text = driver.licenseNumber
        carImageView.image = UIImage(named: driver.car)
        carLabel.text = driver.car
        let ratingString = String(format: "%.1f", driver.rating)
        ratingImageView.image = UIImage(named: "rating-\(ratingString)")
        ratingLabel.text = ratingString
    }
}
