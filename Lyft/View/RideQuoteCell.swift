//
//  RideQuoteCell.swift
//  Lyft
//
//  Created by Weiran Fu on 8/31/20.
//  Copyright © 2020 aranne. All rights reserved.
//

import UIKit

class RideQuoteCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func update(rideQuote: RideQuote) {
        thumbnailImageView.image = UIImage(named: rideQuote.thumbnail)
        titleLabel.text = rideQuote.name
        capacityLabel.text = rideQuote.capacity
        priceLabel.text = String(format: "$%.2f", rideQuote.price)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"  // hours:minutes:AM/PM
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        timeLabel.text = dateFormatter.string(from: rideQuote.time)
    }
}
