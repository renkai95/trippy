//
//  TripTableViewCell.swift
//  trippy
//
//  Created by rk on 5/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {

    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var originOutlet: UILabel!
    @IBOutlet weak var destinationOutlet: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
