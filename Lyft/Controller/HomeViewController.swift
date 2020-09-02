//
//  HomeViewController.swift
//  Lyft
//
//  Created by Weiran Fu on 8/30/20.
//  Copyright © 2020 aranne. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var locations = [Location]()
    var locationManager: CLLocationManager!
    var currentUserLocation: Location!
    var addCarAnnotations = false
    
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
        locations = [recentLocations[0], recentLocations[1], recentLocations[2]]
        
        // Add shadow to searchButton
        searchButton.layer.cornerRadius = 10.0
        searchButton.layer.shadowRadius = 1.0
        searchButton.layer.shadowColor = UIColor.black.cgColor
        searchButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        searchButton.layer.shadowOpacity = 0.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // hide navigation bar
        navigationController?.isNavigationBarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let locationViewController = segue.destination as? LocationViewController {
            locationViewController.pickupLocation = currentUserLocation
        } else if let routeViewController = segue.destination as? RouteViewController,
            let dropoffLocation = sender as? Location {
            routeViewController.pickupLocation = currentUserLocation
            routeViewController.dropoffLocation = dropoffLocation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let firstLocation = locations.first!
        currentUserLocation = Location(title: "Current Location", subtitle: "", latitude: firstLocation.coordinate.latitude, longitude: firstLocation.coordinate.longitude)
        
        // stop update user location
        locationManager.stopUpdatingLocation()
        
        // Create three vehicle annotations
        let latitude = currentUserLocation.latitude
        let longitude = currentUserLocation.longitude
        let offset = 0.00075
        let coord1 = CLLocationCoordinate2D(latitude: latitude - offset, longitude: longitude - offset)
        let coord2 = CLLocationCoordinate2D(latitude: latitude, longitude: longitude + offset)
        let coord3 = CLLocationCoordinate2D(latitude: latitude, longitude: longitude - offset)
        if !addCarAnnotations {
            addCarAnnotations = true
            mapView.addAnnotations([
                VehicleAnnotation(coordinate: coord1),
                VehicleAnnotation(coordinate: coord2),
                VehicleAnnotation(coordinate: coord3)
            ])
        }
        // Zoom into user location
        let distance = 200.0
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
    }
    
    // For async authorization update
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
    
    // perform segue when select a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dropoffLocation = locations[indexPath.row]
        performSegue(withIdentifier: "RouteSegue", sender: dropoffLocation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't change view for default user location annotation
        if annotation is MKUserLocation {
            return nil
        }
        // Create custom annotation for vehicle
        let reuseIdentifier = "VehicleAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            annotationView!.annotation = annotation
        }
        annotationView?.image = UIImage(named: "car")
        annotationView?.transform = CGAffineTransform(rotationAngle: CGFloat(arc4random_uniform(360)) / 180.0 * CGFloat.pi )
        
        return annotationView
    }
}
