//
//  LocationViewController.swift
//  Lyft
//
//  Created by Weiran Fu on 8/31/20.
//  Copyright © 2020 aranne. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MKLocalSearchCompleterDelegate {
    
    @IBOutlet weak var dropoffTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var locations = [Location]()
    var pickupLocation: Location!
    var dropoffLocation: Location?
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locations = LocationService.shared.getRecentLocations()
        
        // Focus on dropoffTextField
        dropoffTextField.becomeFirstResponder()
        dropoffTextField.delegate = self
        
        // Delegate searchCompleter
        searchCompleter.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // show navigation bar
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let latestString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if latestString.count > 3 {
            searchCompleter.queryFragment = latestString
        }
        return true
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        // reload table view
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.isEmpty ? locations.count : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        if searchResults.isEmpty {
            let location = locations[indexPath.row]
            cell.update(location: location)
        } else {
            let searchResult = searchResults[indexPath.row]
            cell.update(searchResult: searchResult)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchResults.isEmpty {
            let location = locations[indexPath.row]
            performSegue(withIdentifier: "RouteSegue", sender: location)
        } else {
            let searchResult = searchResults[indexPath.row]
            // Convert searchResult -> Location obj
            let searchRequest = MKLocalSearch.Request(completion: searchResult)
            let search = MKLocalSearch(request: searchRequest)
            search.start() { (response, error) in
                if error == nil {
                    if let dropoffPlacemark = response?.mapItems.first?.placemark {
                        let location = Location(placemark: dropoffPlacemark)
                        self.performSegue(withIdentifier: "RouteSegue", sender: location)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let routeViewController = segue.destination as? RouteViewController,
            let dropoffLocation = sender as? Location {
            routeViewController.pickupLocation = pickupLocation
            routeViewController.dropoffLocation = dropoffLocation
        }
    }
}
