//
//  InstaCell.swift
//  InstaCopy
//
//  Created by Peyt Spencer Dewar on 1/10/16.
//  Copyright © 2016 PSD. All rights reserved.
//

import UIKit

class InstaCell: UITableViewCell {
    
    @IBOutlet var usernamePic: UIImageView!
    @IBOutlet var usernameText: UILabel!
    @IBOutlet var popularPic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //make circular
        usernamePic.layer.cornerRadius = usernamePic.frame.height / 2
        usernamePic.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
