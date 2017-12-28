//
//  ATMCustomCell.swift
//  ATMFinder-GoogleMaps
//
//  Created by EDI on 28/12/17.
//  Copyright © 2017 EDI. All rights reserved.
//

import UIKit

class ATMCustomCell: UITableViewCell {

    @IBOutlet weak var atmName: UILabel!
    @IBOutlet weak var atmAddress: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
