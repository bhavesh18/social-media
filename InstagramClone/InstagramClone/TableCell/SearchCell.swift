//
//  SearchCell.swift
//  InstagramClone
//
//  Created by Dharam Singh on 09/03/20.
//  Copyright © 2020 Dharam Singh. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
@IBOutlet weak var heading: UILabel!
    @IBOutlet weak var profilepic: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
