//
//  CommentTableViewCell.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 16/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    var delegate: HomePageProtocol!

    @IBOutlet weak var commentUserImg: UIImageView!
    @IBOutlet weak var commentUserName: UILabel!
    @IBOutlet weak var userComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
    
}
