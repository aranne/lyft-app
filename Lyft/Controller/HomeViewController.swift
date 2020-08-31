//
//  HomeViewController.swift
//  Lyft
//
//  Created by Weiran Fu on 8/30/20.
//  Copyright © 2020 aranne. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var searchButton: UIButton!
    
    var locations = [Location]()
    var locationManager: CLLocationManager!
    var currentUserLocation: Location!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Location Manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()     // async request
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        
        let recentLocations = LocationService.shared.getRecentLocations()
        locations = [recentLocations[0], recentLocations[1]]
        
        // Add shadow to searchButton
        searchButton.layer.cornerRadius = 10.0
        searchButton.layer.shadowRadius = 1.0
        searchButton.layer.shadowColor = UIColor.black.cgColor
        searchButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        searchButton.layer.shadowOpacity = 0.5
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let firstLocation = locations.first!
        currentUserLocation = Location(title: "Current Location", subtitle: "", latitude: firstLocation.coordinate.latitude, longitude: firstLocation.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        let location = locations[indexPath.row]
        cell.update(location: location)
        return cell        
    }
}
