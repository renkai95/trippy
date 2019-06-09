//
//  SharedTableViewCell.swift
//  trippy
//
//  Created by rk on 9/6/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class SharedTableViewCell: UITableViewCell {

    @IBOutlet weak var sharedTitleOutlet: UILabel!
    @IBOutlet weak var sharedOriginOutlet: UILabel!
    
    @IBOutlet weak var sharedUserOutlet: UILabel!
    @IBOutlet weak var sharedDestinationOutlet: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
