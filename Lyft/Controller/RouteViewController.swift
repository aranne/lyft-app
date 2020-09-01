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
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var dropoffLabel: UILabel!
    
    var pickupLocation: Location!
    var dropoffLocation: Location!
    var rideQuotes = [RideQuote]()
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rounding all the corners
        routeLabelContainer.layer.cornerRadius = 10.0
        backButton.layer.cornerRadius = backButton.frame.size.width / 2.0
        selectRideButton.layer.cornerRadius = 10.0
        
        // update pickup and dropoff labels
        pickupLabel.text = pickupLocation?.title
        dropoffLabel.text = dropoffLocation?.title
        
        // get ride quotes
        rideQuotes = RideQuoteService.shared.getQuotes(pickupLocation: pickupLocation!, dropoffLocation: dropoffLocation!)
        
        // Add annotaions to map view
        let pickupCoordinate = CLLocationCoordinate2D(latitude: pickupLocation!.latitude, longitude: pickupLocation!.longitude)
        let dropoffCoordinate = CLLocationCoordinate2D(latitude: dropoffLocation!.latitude, longitude: dropoffLocation!.longitude)
        let pickupAnnotation = LocationAnnotation(coordinate: pickupCoordinate, locationType: "pickup")
        let dropoffAnnotation = LocationAnnotation(coordinate: dropoffCoordinate, locationType: "dropoff")
        mapView.addAnnotations([pickupAnnotation, dropoffAnnotation])
        // Customize annotation
        mapView.delegate = self
        
        // Display route
        displayRoute(sourceLocation: pickupLocation!, destinationLocation: dropoffLocation!)
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
