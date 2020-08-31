//
//  LocationCell.swift
//  Lyft
//
//  Created by Weiran Fu on 8/30/20.
//  Copyright © 2020 aranne. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    
    @IBOutlet weak var addressLine1Label: UILabel!
    @IBOutlet weak var addressLine2Label: UILabel!
    
    
    func update(location: Location) {
        addressLine1Label.text = location.title
        addressLine2Label.text = location.subtitle
    }
}
