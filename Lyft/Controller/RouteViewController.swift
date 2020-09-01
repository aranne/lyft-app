//
//  RouteViewController.swift
//  Lyft
//
//  Created by Weiran Fu on 8/31/20.
//  Copyright © 2020 aranne. All rights reserved.
//

import UIKit
import MapKit

class RouteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var routeLabelContainer: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var selectRideButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var pickupLocation: Location?
    var dropoffLocation: Location?
    var rideQuotes = [RideQuote]()
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rounding all the corners
        routeLabelContainer.layer.cornerRadius = 10.0
        backButton.layer.cornerRadius = backButton.frame.size.width / 2.0
        selectRideButton.layer.cornerRadius = 10.0
        
        let locations = LocationService.shared.getRecentLocations()
        pickupLocation = locations[0]
        dropoffLocation = locations[1]
        
        rideQuotes = RideQuoteService.shared.getQuotes(pickupLocation: pickupLocation!, dropoffLocation: dropoffLocation!)
        
        // Add annotaions to map view
        let pickupCoordinate = CLLocationCoordinate2D(latitude: pickupLocation!.latitude, longitude: pickupLocation!.longitude)
        let dropoffCoordinate = CLLocationCoordinate2D(latitude: dropoffLocation!.latitude, longitude: dropoffLocation!.longitude)
        let pickupAnnotation = LocationAnnotation(coordinate: pickupCoordinate, locationType: "pickup")
        let dropoffAnnotation = LocationAnnotation(coordinate: dropoffCoordinate, locationType: "dropoff")
        mapView.addAnnotations([pickupAnnotation, dropoffAnnotation])
        // Customize annotation
        mapView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideQuotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RideQuoteCell") as! RideQuoteCell
        let rideQuote = rideQuotes[indexPath.row]
        cell.update(rideQuote: rideQuote)
        cell.updateSelectStatus(status: indexPath.row == selectedIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let selectRideQuote = rideQuotes[selectedIndex]
        selectRideButton.setTitle("Select \(selectRideQuote.name)", for: .normal)
        tableView.reloadData()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseIdentifier = "LocationAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            annotationView!.annotation = annotation
        }
        let locationAnnotation = annotation as! LocationAnnotation
        annotationView!.image = UIImage(named: "dot-\(locationAnnotation.locationType)")
        return annotationView
    }
}
