//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Julien Calfayan on 2/19/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var tweetContent: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profilePicture.layer.cornerRadius = 35
        profilePicture.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
