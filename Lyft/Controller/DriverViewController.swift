//
//  DriverViewController.swift
//  Lyft
//
//  Created by Weiran Fu on 9/2/20.
//  Copyright © 2020 aranne. All rights reserved.
//

import UIKit
import MapKit

class DriverViewController: UIViewController, MKMapViewDelegate {
    
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
        
        mapView.delegate = self
        
        // Add annotations
        let driverAnnotation = VehicleAnnotation(coordinate: driver.coordinate)
        let pickupCoordinate = CLLocationCoordinate2D(latitude: pickupLocation.latitude, longitude: pickupLocation.longitude)
        let dropoffCoordinate = CLLocationCoordinate2D(latitude: dropoffLocation.latitude, longitude: dropoffLocation.longitude)
        let pickupAnnotation = LocationAnnotation(coordinate: pickupCoordinate, locationType: "pickup")
        let dropoffAnnotation = LocationAnnotation(coordinate: dropoffCoordinate, locationType: "dropoff")
        
        let annotations: [MKAnnotation] = [driverAnnotation, pickupAnnotation, dropoffAnnotation]
        mapView.addAnnotations(annotations)
        
        // Zoom into all annotations
        mapView.showAnnotations(annotations, animated: false)
        
        let driverLocation = Location(title: driver.name, subtitle: driver.licenseNumber, latitude: driver.coordinate.latitude, longitude: driver.coordinate.longitude)
        displayRoute(sourceLocation: driverLocation, destinationLocation: pickupLocation)
    }
    
    @IBAction func backButtonDidTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editRideButtonDidTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseIdentifier = annotation is VehicleAnnotation ? "VehicleAnnotation" : "LocationAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        if annotation is VehicleAnnotation {
            annotationView?.image = UIImage(named: "car")
        } else if let locationAnnotation = annotation as? LocationAnnotation {
            annotationView?.image = UIImage(named: "dot-\(locationAnnotation.locationType)")
        }
        return annotationView
    }
    
    // cutomize renderer for polyline renderer
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
       let renderer = MKPolylineRenderer(overlay: overlay)
       renderer.lineWidth = 5.0
       renderer.strokeColor = UIColor(red: 247.0 / 255.0, green: 66.0 / 255.0, blue: 190.0 / 255.0, alpha: 1.0)
       return renderer
    }
    
    func displayRoute(sourceLocation: Location, destinationLocation: Location) {
        let sourceCoordinate = CLLocationCoordinate2D(latitude: sourceLocation.latitude, longitude: sourceLocation.longitude)
        let destinationCoordinate = CLLocationCoordinate2D(latitude: destinationLocation.latitude, longitude: destinationLocation.longitude)
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationCoordinate)

        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile

        let directions = MKDirections(request: directionRequest)
        directions.calculate() { (respond, error) in
        if let error = error {
           print("There's an error with calculating route \(error)")
           return
        }
        guard let respond = respond else {
           return
        }
           
        // add route overlay
        let route = respond.routes[0]  // get the first route
        self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
        // zoom into the route
        let EDGE_INSET: CGFloat = 80.0
        let boundingMapRect = route.polyline.boundingMapRect
        self.mapView.setVisibleMapRect(boundingMapRect, edgePadding: UIEdgeInsets(top: EDGE_INSET, left: EDGE_INSET, bottom: EDGE_INSET, right: EDGE_INSET), animated: true)
        }
    }
}
