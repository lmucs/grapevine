//
//  NoEventsTableViewCell.swift
//  Grapevine
//
//  Created by Matthew Flickner on 12/11/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit

class NoEventsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
