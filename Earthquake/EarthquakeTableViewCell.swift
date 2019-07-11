//
//  EarthquakeTableViewCell.swift
//  Earthquake
//
//  Created by Charlie Draper on 7/8/19.
//  Copyright © 2019 Charlie Draper. All rights reserved.
//

import UIKit

class EarthquakeTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var magLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var magImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
