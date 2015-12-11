//
//  FeedTableViewCell.swift
//  Grapevine
//
//  Created by Matthew Flickner on 12/7/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var feedNameLabel: UILabel!
    @IBOutlet weak var feedNetwork: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
