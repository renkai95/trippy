//
//  SharedTableViewCell.swift
//  trippy
//
//  Created by rk on 9/6/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class SharedTableViewCell: UITableViewCell {

    @IBOutlet weak var titleOutlet: UILabel!

    @IBOutlet weak var originOutlet: UILabel!
    @IBOutlet weak var destinationOutlet: UILabel!
    
    @IBOutlet weak var userOutlet: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
