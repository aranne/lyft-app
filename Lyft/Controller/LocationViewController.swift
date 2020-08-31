//
//  LocationViewController.swift
//  Lyft
//
//  Created by Weiran Fu on 8/31/20.
//  Copyright © 2020 aranne. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UITableViewDataSource {
    
    var locations = [Location]()
    var pickupLocation: Location?
    var dropoffLocation: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locations = LocationService.shared.getRecentLocations()
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
