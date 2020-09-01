//
//  RouteViewController.swift
//  Lyft
//
//  Created by Weiran Fu on 8/31/20.
//  Copyright © 2020 aranne. All rights reserved.
//

import UIKit

class RouteViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var routeLabelContainer: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var selectRideButton: UIButton!
    
    var pickupLocation: Location?
    var dropoffLocation: Location?
    var rideQuotes = [RideQuote]()
    
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideQuotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RideQuoteCell") as! RideQuoteCell
        let rideQuote = rideQuotes[indexPath.row]
        cell.update(rideQuote: rideQuote)
        return cell
    }
}
